#!/usr/bin/env python

lines = [row.strip() for row in open('01.input').readlines()]

sum = 0

for line in lines:
    numerals = [c for c in line if c.isdigit()]
    sum += int(numerals[0] + numerals[-1])

print(sum)
