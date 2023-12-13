#!/usr/bin/env python

import numpy


class Pattern:
    def __init__(self, lines):
        self.height = len(lines)
        self.width = len(lines[0])
        self.map = numpy.zeros((self.height, self.width), dtype=numpy.uint8)
        for y in range(self.height):
            for x in range(self.width):
                if lines[y][x] == '#':
                    self.map[y, x] = 1

    def is_horizontal_reflection(self, candidate_row):
        if candidate_row <= 0 or candidate_row >= self.height:
            return False

        for check_offset in range(1, min([candidate_row, self.height - candidate_row]) + 1):
            for x in range(self.width):
                if self.map[candidate_row + check_offset - 1, x] != \
                   self.map[candidate_row - check_offset, x]:
                    return False

        return True

    def is_vertical_reflection(self, candidate_col):
        if candidate_col <= 0 or candidate_col >= self.width:
            return False

        for check_offset in range(1, min([candidate_col, self.width - candidate_col]) + 1):
            for y in range(self.height):
                if self.map[y, candidate_col + check_offset - 1] != \
                   self.map[y, candidate_col - check_offset]:
                    return False

        return True

    def score_horizontal_reflection(self):
        for candidate_row in range(1, self.height):
            if self.is_horizontal_reflection(candidate_row):
                return 100 * candidate_row
        return 0

    def score_vertical_reflection(self):
        for candidate_col in range(1, self.width):
            if self.is_vertical_reflection(candidate_col):
                return candidate_col
        return 0

    def score(self):
        return self.score_horizontal_reflection() + \
            self.score_vertical_reflection()

    def __str__(self):
        return str(self.map)


lines = [line.strip() for line in open('13.input').readlines()]

patterns = []
buffer = []
for line in lines:
    if len(line) == 0:
        patterns.append(Pattern(buffer))
        buffer = []
    else:
        buffer.append(line)

patterns.append(Pattern(buffer))

print(sum([p.score() for p in patterns]))
