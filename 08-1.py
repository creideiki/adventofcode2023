#!/usr/bin/env python

import re
from collections import namedtuple

lines = [row.strip() for row in open('08.input').readlines()]

line_format = re.compile("^(?P<from>[A-Z]+) = \\((?P<left>[A-Z]+), (?P<right>[A-Z]+)\\)$")

insns = lines[0]

Node = namedtuple('Node', ['L', 'R'])
nodes = {}
for line in lines[2:]:
    m = line_format.match(line)
    nodes[m['from']] = Node(L=m['left'], R=m['right'])

node = 'AAA'
ip = 0
steps = 0
while node != 'ZZZ':
    node = getattr(nodes[node], insns[ip])
    ip = (ip + 1) % len(insns)
    steps += 1

print(steps)
