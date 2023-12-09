#!/usr/bin/env python

from collections import deque

lines = [list(map(lambda c: int(c), line.split())) for line in open('09.input').readlines()]

sums = 0
for l in lines:
    differences = []
    current_list = l
    current_diff = deque([])
    while set(current_diff) != set([0]):
        current_diff = deque([])
        for n in range(len(current_list) - 1):
            current_diff.append(current_list[n + 1] - current_list[n])
        current_list = current_diff
        differences.append(current_diff)

    for n in range(len(differences) - 1, -1, -1):
        differences[n - 1].appendleft(differences[n - 1][0] - differences[n][0])

    sums += l[0] - differences[0][0]

print(sums)
