#!/usr/bin/env python

import re

lines = [row.strip() for row in open('01.input').readlines()]

numeral_pattern = re.compile("[1-9]|one|two|three|four|five|six|seven|eight|nine")

def name_to_numeral(name):
    numerals = {
        'one':   '1',
        'two':   '2',
        'three': '3',
        'four':  '4',
        'five':  '5',
        'six':   '6',
        'seven': '7',
        'eight': '8',
        'nine':  '9'
    }
    if name.isdigit():
        return name
    return numerals[name]


def scan_string(s):
    if s == '':
        return []
    elif m := re.match(numeral_pattern, s):
        return [m[0]] + scan_string(s[1:])
    else:
        return scan_string(s[1:])


sum = 0

for line in lines:
    numerals = scan_string(line)
    sum += int(name_to_numeral(numerals[0]) +
               name_to_numeral(numerals[-1]))

print(sum)
