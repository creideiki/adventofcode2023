#!/usr/bin/env python

import re
from collections import deque

lines = [row.strip() for row in open('02.input').readlines()]

line_format = re.compile("^Game (?P<num>[0-9]+): (?P<reveals>.*)$")

games = {}

for line in lines:
    m = re.match(line_format, line)
    games[int(m['num'])] = []
    reveals = m['reveals'].split(';')
    for reveal in reveals:
        colours = {
            'red': 0,
            'green': 0,
            'blue': 0
        }
        tokens = deque(reveal.replace(',', '').split())
        while len(tokens) > 0:
            num = int(tokens.popleft())
            colour = tokens.popleft()
            colours[colour] = num

        games[int(m['num'])].append(colours)


def power(game):
    required = {
        'red': 0,
        'green': 0,
        'blue': 0
    }
    for reveal in game:
        for colour in ['red', 'green', 'blue']:
            required[colour] = max(required[colour], reveal[colour])
    return required['red'] * required['green'] * required['blue']


sum = 0
for game in games.values():
    sum += power(game)

print(sum)
