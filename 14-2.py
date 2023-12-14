#!/usr/bin/env python

import numpy


class Dish:
    def __init__(self, lines):
        self.height = len(lines)
        self.width = len(lines[0])
        self.map = numpy.zeros((self.height, self.width), dtype=numpy.uint8)
        for y in range(self.height):
            for x in range(self.width):
                if lines[y][x] == 'O':
                    self.map[y, x] = 1
                elif lines[y][x] == '#':
                    self.map[y, x] = 2

    def load(self):
        load = 0
        for y in range(self.height):
            for x in range(self.width):
                if self.map[y, x] == 1:
                    load += self.height - y
        return load

    def move_north(self, start_y, x):
        end_y = start_y
        for check_y in range((start_y - 1), -1, -1):
            if self.map[check_y, x] != 0:
                break
            end_y = check_y
        self.map[start_y, x] = 0
        self.map[end_y, x] = 1
        return end_y

    def move_south(self, start_y, x):
        end_y = start_y
        for check_y in range((start_y + 1), self.height):
            if self.map[check_y, x] != 0:
                break
            end_y = check_y
        self.map[start_y, x] = 0
        self.map[end_y, x] = 1
        return end_y

    def move_west(self, y, start_x):
        end_x = start_x
        for check_x in range((start_x - 1), -1, -1):
            if self.map[y, check_x] != 0:
                break
            end_x = check_x
        self.map[y, start_x] = 0
        self.map[y, end_x] = 1
        return end_x

    def move_east(self, y, start_x):
        end_x = start_x
        for check_x in range((start_x + 1), self.width):
            if self.map[y, check_x] != 0:
                break
            end_x = check_x
        self.map[y, start_x] = 0
        self.map[y, end_x] = 1
        return end_x

    def tilt_north(self):
        for y in range(self.height):
            for x in range(self.width):
                if self.map[y, x] == 1:
                    self.move_north(y, x)

    def tilt_south(self):
        for y in range((self.height - 1), -1, -1):
            for x in range(self.width):
                if self.map[y, x] == 1:
                    self.move_south(y, x)

    def tilt_west(self):
        for y in range(self.height):
            for x in range(self.width):
                if self.map[y, x] == 1:
                    self.move_west(y, x)

    def tilt_east(self):
        for y in range(self.height):
            for x in range((self.width - 1), -1, -1):
                if self.map[y, x] == 1:
                    self.move_east(y, x)

    def cycle(self):
        self.tilt_north()
        self.tilt_west()
        self.tilt_south()
        self.tilt_east()

    def spin(self):
        seen = []
        num_cycles = 0
        cycle_length = 0
        while True:
            seen.append(numpy.copy(self.map))
            self.cycle()
            num_cycles += 1
            matches = [numpy.array_equal(c, self.map) for c in seen]
            if any(matches):
                cycle_length = num_cycles - matches.index(True)
                break
        skip_cycles = (1_000_000_000 - num_cycles) // cycle_length
        remainder = (1_000_000_000 - num_cycles) % cycle_length
        for _ in range(remainder):
            self.cycle()

    def __str__(self):
        s = f"<{self.__class__.__name__}:\n"
        for y in range(self.height):
            for x in range(self.width):
                match self.map[y, x]:
                    case 0:
                        s += "."
                    case 1:
                        s += "O"
                    case 2:
                        s += "#"
            s += "\n"
        s += ">"
        return s


lines = [line.strip() for line in open('14.input').readlines()]

dish = Dish(lines)
dish.spin()
print(dish.load())
