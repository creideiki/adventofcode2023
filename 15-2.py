#!/usr/bin/env python

def HASH(string):
    value = 0
    for c in string:
        value = ((value + ord(c)) * 17) % 256
    return value


class Lens:
    def __init__(self, focal_length, label):
        self.focal_length = int(focal_length)
        self.label = label


class Box:
    def __init__(self, index):
        self.index = int(index)
        self.lenses = []

    def is_empty(self):
        return len(self.lenses) == 0

    def power(self):
        box_power = 0
        for i in range(len(self.lenses)):
            box_power += (self.index + 1) * (i + 1) * self.lenses[i].focal_length
        return box_power

    def insert(self, focal_length, label):
        old_index = -1
        for i in range(len(self.lenses)):
            if self.lenses[i].label == label:
                old_index = i
                break
        if old_index != -1:
            self.lenses.insert(old_index, Lens(focal_length, label))
            del self.lenses[old_index + 1]
        else:
            self.lenses.append(Lens(focal_length, label))

    def remove(self, label):
        found = -1
        for i in range(len(self.lenses)):
            if self.lenses[i].label == label:
                found = i
                break
        if found != -1:
            del self.lenses[i]


input = open('15.input').readlines()[0].strip().split(",")

boxes = []
for i in range(256):
    boxes.append(Box(i))

for instruction in input:
    if "=" in instruction:
        label, focal_length = instruction.split("=")
        box_num = HASH(label)
        boxes[box_num].insert(focal_length, label)
    elif "-" in instruction:
        label = instruction.split("-")[0]
        box_num = HASH(label)
        boxes[box_num].remove(label)
    else:
        exit(1)

print(sum([b.power() for b in boxes]))
