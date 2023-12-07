#!/usr/bin/env python

class Hand:
    type_order = ['card', 'one_pair', 'two_pair', 'three', 'full_house', 'four', 'five']
    card_order = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

    def __init__(self, cards, bid):
        self.cards = cards
        self.bid = bid
        self.hand_type = self.classify()

    def classify(self):
        temp = sorted(self.cards)

        if temp[0] == temp[1] == temp[2] == temp[3] == temp[4]:
            return 'five'
        elif temp[0] == temp[1] == temp[2] == temp[3] or \
             temp[1] == temp[2] == temp[3] == temp[4]:
            return 'four'
        elif (temp[0] == temp[1] and temp[2] == temp[3] and temp[3] == temp[4]) or \
             (temp[0] == temp[1] and temp[1] == temp[2] and temp[3] == temp[4]):
            return 'full_house'
        elif temp[0] == temp[1] == temp[2] or \
             temp[1] == temp[2] == temp[3] or \
             temp[2] == temp[3] == temp[4]:
            return 'three'
        elif (temp[0] == temp[1] and temp[2] == temp[3]) or \
             (temp[0] == temp[1] and temp[3] == temp[4]) or \
             (temp[1] == temp[2] and temp[3] == temp[4]):
            return 'two_pair'
        elif temp[0] == temp[1] or \
             temp[1] == temp[2] or \
             temp[2] == temp[3] or \
             temp[3] == temp[4]:
            return 'one_pair'
        else:
            return 'card'

    def __lt__(self, other):
        if self.type_order.index(self.hand_type) < self.type_order.index(other.hand_type):
            return True
        if self.type_order.index(self.hand_type) > self.type_order.index(other.hand_type):
            return False

        for n in range(len(self.cards)):
            if self.card_order.index(self.cards[n]) < self.card_order.index(other.cards[n]):
                return True
            if self.card_order.index(self.cards[n]) > self.card_order.index(other.cards[n]):
                return False

        return False

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.cards}, {self.bid}: {self.hand_type}>"

    def __repr__(self):
        return str(self)


lines = [row.strip() for row in open('07.input').readlines()]

hands = []
for line in lines:
    hands.append(Hand(line.split()[0], int(line.split()[1])))

hands.sort()

winnings = 0
for i in range(len(hands)):
    winnings += hands[i].bid * (i + 1)

print(winnings)
