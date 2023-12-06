#!/usr/bin/env python

lines = [row.strip() for row in open('06.input').readlines()]

times = [int(n) for n in lines[0].split(':')[1].split()]
records = [int(n) for n in lines[1].split(':')[1].split()]

num = 1
for race in range(len(times)):
    time = times[race]
    record = records[race]

    wins = 0
    for hold in range(time + 1):
        speed = hold
        distance = (time - hold) * speed
        if distance > record:
            wins += 1

    if wins > 1:
        num *= wins

print(num)
