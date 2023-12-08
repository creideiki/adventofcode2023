#!/usr/bin/env python

import re
from collections import namedtuple
from math import lcm

lines = [row.strip() for row in open('08.input').readlines()]

line_format = re.compile("^(?P<from>[0-9A-Z]+) = \\((?P<left>[0-9A-Z]+), (?P<right>[0-9A-Z]+)\\)$")

insns = lines[0]

Node = namedtuple('Node', ['L', 'R'])
nodes = {}
for line in lines[2:]:
    m = line_format.match(line)
    nodes[m['from']] = Node(L=m['left'], R=m['right'])

start_nodes = [n for n in nodes.keys() if n.endswith('A')]
num_threads = len(start_nodes)
steps = [0] * num_threads

for n in range(num_threads):
    ip = 0
    node = start_nodes[n]
    while not node.endswith('Z'):
        node = getattr(nodes[node], insns[ip])
        ip = (ip + 1) % len(insns)
        steps[n] += 1

print(lcm(*steps))
