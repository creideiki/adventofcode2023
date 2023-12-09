#!/usr/bin/env python

lines = [list(map(lambda c: int(c), line.split())) for line in open('09.input').readlines()]

sums = 0
for l in lines:
    differences = []
    current_list = l
    current_diff = []
    while set(current_diff) != set([0]):
        current_diff = []
        for n in range(len(current_list) - 1):
            current_diff.append(current_list[n + 1] - current_list[n])
        current_list = current_diff
        differences.append(current_diff)

    for n in range(len(differences) - 1, -1, -1):
        differences[n - 1].append(differences[n - 1][-1] + differences[n][-1])

    sums += l[-1] + differences[0][-1]

print(sums)
