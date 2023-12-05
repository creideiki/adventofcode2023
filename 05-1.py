#!/usr/bin/env python

class Map:
    def __init__(self, from_type, to_type):
        self.from_type = from_type
        self.to_type = to_type
        self.mappings = []

    def add_mapping(self, source, destination, length):
        self.mappings.append({'source': source, 'destination': destination, 'length': length})

    def covers(self, source, length, test):
        return test >= source and \
            test < source + length

    def __getitem__(self, input):
        for mapping in self.mappings:
            if self.covers(mapping['source'], mapping['length'], input):
                return mapping['destination'] - mapping['source'] + input
        return input

    def __str__(self):
        s = f"<{self.__class__.__name__} {self.from_type}-{to_type}: "
        for m in self.mappings:
            s += f"{m['source']} {m['length']} {m['destination']} "
        s += ">"
        return s


input = [row.strip() for row in open('05.input').readlines()]

seeds = None
maps = []
mapping = None

for line in input:
    if line.startswith('seeds: '):
        seeds = [int(s) for s in line.split(':')[1].split()]
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

locations = []
for seed in seeds:
    from_type = 'seed'
    pos = seed
    while True:
        mapping = None
        for m in maps:
            if m.from_type == from_type:
                mapping = m
                break
        to_type = mapping.to_type
        pos = mapping[pos]
        if to_type == 'location':
            break
        from_type = to_type
    locations.append(pos)

print(min(locations))
