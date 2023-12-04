#!/usr/bin/env python

import re

lines = [row.strip() for row in open('04.input').readlines()]

card_format = re.compile("^Card +(?P<num>[0-9]+): (?P<winning>[0-9 ]*)\\|(?P<have>[0-9 ]*)$")

score = 0
for line in lines:
    m = card_format.match(line)
    winning = set([int(n) for n in m['winning'].split()])
    have = set([int(n) for n in m['have'].split()])

    if len(winning & have) > 0:
        score += 2 ** (len(winning & have) - 1)
    else:
        score += 0

print(score)
