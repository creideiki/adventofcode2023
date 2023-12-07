#!/usr/bin/env python

class Hand:
    type_order = ['card', 'one_pair', 'two_pair', 'three', 'full_house', 'four', 'five']
    card_order = ['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']

    def __init__(self, cards, bid):
        self.cards = cards
        self.bid = bid
        self.hand_type = self.classify()

    def classify(self):
        non_jokers = sorted([c for c in self.cards if c != 'J'])
        num_jokers = len([c for c in self.cards if c == 'J'])

        match num_jokers:
            case 5:
                return 'five'
            case 4:
                return 'five'
            case 3:
                if non_jokers[0] == non_jokers[1]:
                    return 'five'
                else:
                    return 'four'
            case 2:
                if non_jokers[0] == non_jokers[1] and non_jokers[1] == non_jokers[2]:
                    return 'five'
                elif non_jokers[0] == non_jokers[1] or non_jokers[1] == non_jokers[2]:
                    return 'four'
                else:
                    return 'three'
            case 1:
                if non_jokers[0] == non_jokers[1] == non_jokers[2] == non_jokers[3]:
                    return 'five'
                elif non_jokers[0] == non_jokers[1] == non_jokers[2] or \
                     non_jokers[1] == non_jokers[2] == non_jokers[3]:
                    return 'four'
                elif non_jokers[0] == non_jokers[1] and non_jokers[2] == non_jokers[3]:
                    return 'full_house'
                elif non_jokers[0] == non_jokers[1] or \
                     non_jokers[1] == non_jokers[2] or \
                     non_jokers[2] == non_jokers[3]:
                    return 'three'
                else:
                    return 'one_pair'
            case 0:
                if non_jokers[0] == non_jokers[1] == non_jokers[2] == non_jokers[3] == non_jokers[4]:
                    return 'five'
                elif non_jokers[0] == non_jokers[1] == non_jokers[2] == non_jokers[3] or \
                     non_jokers[1] == non_jokers[2] == non_jokers[3] == non_jokers[4]:
                    return 'four'
                elif (non_jokers[0] == non_jokers[1] and non_jokers[2] == non_jokers[3] and non_jokers[3] == non_jokers[4]) or \
                     (non_jokers[0] == non_jokers[1] and non_jokers[1] == non_jokers[2] and non_jokers[3] == non_jokers[4]):
                    return 'full_house'
                elif non_jokers[0] == non_jokers[1] == non_jokers[2] or \
                     non_jokers[1] == non_jokers[2] == non_jokers[3] or \
                     non_jokers[2] == non_jokers[3] == non_jokers[4]:
                    return 'three'
                elif (non_jokers[0] == non_jokers[1] and non_jokers[2] == non_jokers[3]) or \
                     (non_jokers[0] == non_jokers[1] and non_jokers[3] == non_jokers[4]) or \
                     (non_jokers[1] == non_jokers[2] and non_jokers[3] == non_jokers[4]):
                    return 'two_pair'
                elif non_jokers[0] == non_jokers[1] or \
                     non_jokers[1] == non_jokers[2] or \
                     non_jokers[2] == non_jokers[3] or \
                     non_jokers[3] == non_jokers[4]:
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
