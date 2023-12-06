#!/usr/bin/env python

lines = [row.strip() for row in open('06.input').readlines()]

time = int(lines[0].split(':')[1].replace(' ', ''))
record = int(lines[1].split(':')[1].replace(' ', ''))

wins = 0
for hold in range(time + 1):
    speed = hold
    distance = (time - hold) * speed
    if distance > record:
        wins += 1

print(wins)
