#!/usr/bin/env python

from collections import namedtuple


class Number:
    def __init__(self, x, y):
        self.left = x
        self.right = x
        self.up = y
        self.down = y
        self.value = 0

    def add_digit(self, digit, x, y):
        self.value = self.value * 10 + int(digit)
        self.right = x

    def is_adjacent(self, pos):
        return pos.x >= self.left - 1 and \
            pos.x <= self.right + 1 and \
            pos.y >= self.up - 1 and \
            pos.y <= self.down + 1

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.value}, l: {self.left}, r: {self.right}, u: {self.up}, d:{self.down}>"


class Gear:
    def __init__(self, pos):
        self.pos = pos
        self.parts = []

    def add_part(self, num):
        self.parts.append(num)

    def is_valid(self):
        return len(self.parts) == 2

    def ratio(self):
        return self.parts[0].value * self.parts[1].value

    def __str__(self):
        return f"<{self.__class__.__name__}: valid: {self.is_valid()}, x: {self.pos.x}, y: {self.pos.y}, parts: {self.parts}>"


input = [row.strip() for row in open('03.input').readlines()]

numbers = []
symbols = []
gears = []

for y in range(len(input)):
    current_number = None
    row = input[y]
    for x in range(len(row)):
        char = row[x]
        match char:
            case '.':
                current_number = None
            case '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9':
                if not current_number:
                    current_number = Number(x, y)
                    numbers.append(current_number)
                current_number.add_digit(char, x, y)
            case _:
                current_number = None
                pos = namedtuple('Position', ['x', 'y'])
                pos.x = x
                pos.y = y
                symbols.append(pos)
                if char == '*':
                    gears.append(Gear(pos))

for gear in gears:
    for num in numbers:
        if num.is_adjacent(gear.pos):
            gear.add_part(num)

print(sum([g.ratio() for g in gears if g.is_valid()]))
