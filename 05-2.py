#!/usr/bin/env python

from collections import deque


class Mapping:
    def __init__(self, first, last, destination, length):
        self.first = first
        self.last = last
        self.length = length
        self.destination = destination

    def __lt__(self, other):
        return self.first < other.first


class Range:
    def __init__(self, low, high):
        self.low = low
        self.high = high

    def __lt__(self, other):
        return self.low < other.low

    def __eq__(self, other):
        return self.low == other.low and \
            self.high == other.high

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.low}-{self.high}>"


class Map:
    def __init__(self, from_type, to_type):
        self.from_type = from_type
        self.to_type = to_type
        self.mappings = []

    def add_mapping(self, first, destination, length):
        self.mappings.append(Mapping(first, first + length - 1, destination, length))
        self.mappings.sort()

    def __getitem__(self, input):
        for mapping in self.mappings:
            if input >= mapping.first and input <= mapping.last:
                return mapping.destination - mapping.first + input
        return input

    def transform(self, source):
        ranges = self.split(source)
        return [Range(self[r.low], self[r.high]) for r in ranges]

    def split(self, input):
        low = input.low
        high = input.high
        ranges = []

        for mapping in self.mappings:
            if low > mapping.last or high < mapping.first:
                continue

            if low < mapping.first and high >= mapping.first:
                ranges.append(Range(low, mapping.first - 1))
                low = mapping.first

            if high > mapping.last:
                ranges.append(Range(low, mapping.last))
                low = mapping.last + 1

        if high > low:
            ranges.append(Range(low, high))

        return sorted(ranges)

    def __str__(self):
        s = f"<{self.__class__.__name__} {self.from_type}-{self.to_type}:\n"
        for m in self.mappings:
            s += f"first={m.first}, last={m.last}, destination={m.destination} , length={m.length}\n"
        s += ">"
        return s


input = [row.strip() for row in open('05.input').readlines()]

ranges = deque([])
maps = []
mapping = None

for line in input:
    if line.startswith('seeds: '):
        seed_input = deque([int(s) for s in line.split(':')[1].split()])
        while len(seed_input) > 0:
            first = seed_input.popleft()
            length = seed_input.popleft()
            ranges.append(Range(first, first + length - 1))
    elif len(line) == 0:
        if mapping is not None:
            maps.append(mapping)
        mapping = None
    elif line.endswith('map:'):
        names = line.split()[0].split('-')
        mapping = Map(names[0], names[2])
    else:
        nums = [int(n) for n in line.split()]
        mapping.add_mapping(nums[1], nums[0], nums[2])

maps.append(mapping)

final_ranges = []
from_type = 'seed'
while True:
    next_ranges = deque([])
    mapping = None
    for m in maps:
        if m.from_type == from_type:
            mapping = m
    to_type = mapping.to_type

    while len(ranges) > 0:
        r = ranges.popleft()
        next_ranges += mapping.transform(r)

    from_type = to_type

    temp_ranges = []
    for r in next_ranges:
        if r not in temp_ranges:
            temp_ranges.append(r)
    ranges = deque(sorted(temp_ranges))

    if to_type == 'location':
        final_ranges = ranges
        break

print(final_ranges[0].low)
