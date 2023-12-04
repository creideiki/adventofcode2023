#!/usr/bin/env python

import re

lines = [row.strip() for row in open('04.input').readlines()]

card_format = re.compile("^Card +(?P<num>[0-9]+): (?P<winning>[0-9 ]*)\\|(?P<have>[0-9 ]*)$")

cards = [{'wins': 0, 'copies': 0}]

for line in lines:
    m = card_format.match(line)
    winning = set([int(n) for n in m['winning'].split()])
    have = set([int(n) for n in m['have'].split()])
    cards.append({'wins': len(winning & have), 'copies': 1})

for card_num in range(len(cards)):
    for n in range(cards[card_num]['wins']):
        cards[card_num + n + 1]['copies'] += cards[card_num]['copies']

num_cards = 0
for card in cards:
    num_cards += card['copies']

print(num_cards)
