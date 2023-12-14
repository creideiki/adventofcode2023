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

    def tilt_north(self):
        for y in range(self.height):
            for x in range(self.width):
                if self.map[y, x] == 1:
                    self.move_north(y, x)

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
dish.tilt_north()
print(dish.load())
