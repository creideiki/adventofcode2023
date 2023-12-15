#!/usr/bin/env python

def HASH(string):
    value = 0
    for c in string:
        value = ((value + ord(c)) * 17) % 256
    return value


input = open('15.input').readlines()[0].strip().split(",")
print(sum([HASH(s) for s in input]))
