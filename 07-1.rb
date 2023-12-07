#!/usr/bin/env ruby

class Hand
  attr_accessor :cards, :bid, :type

  include Comparable

  def initialize(cards, bid)
    @cards = cards.chars
    @bid = bid
    @type = classify
  end

  @@type_order = [:card, :one_pair, :two_pair, :three, :full_house, :four, :five]
  @@card_order = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']

  def classify
    temp = cards.sort
    if temp.all? { |c| c == temp[0] }
      :five
    elsif temp[0..3].all? { |c| c == temp[0] } or
         temp[1..4].all? { |c| c == temp[1] }
      :four
    elsif (temp[0] == temp[1] and temp[2] == temp[3] and temp[3] == temp[4]) or
         (temp[0] == temp[1] and temp[1] == temp[2] and temp[3] == temp[4])
      :full_house
    elsif temp[0..2].all? { |c| c == temp[0] } or
         temp[1..3].all? { |c| c == temp[1] } or
         temp[2..4].all? { |c| c == temp[2] }
      :three
    elsif (temp[0] == temp[1] and temp[2] == temp[3]) or
         (temp[0] == temp[1] and temp[3] == temp[4]) or
         (temp[1] == temp[2] and temp[3] == temp[4])
      :two_pair
    elsif temp[0] == temp[1] or
         temp[1] == temp[2] or
         temp[2] == temp[3] or
         temp[3] == temp[4]
      :one_pair
    else
      :card
    end
  end

  def <=>(other)
    return -1 if @@type_order.index(@type) < @@type_order.index(other.type)
    return  1 if @@type_order.index(@type) > @@type_order.index(other.type)

    @cards.each_index do |n|
      return -1 if @@card_order.index(@cards[n]) < @@card_order.index(other.cards[n])
      return  1 if @@card_order.index(@cards[n]) > @@card_order.index(other.cards[n])
    end

    0
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class}: #{@cards.join}, #{@bid}: #{@type}>"
  end
end

input = File.read('07.input').lines.map(&:strip)

hands = []
input.each do |line|
  hands << Hand.new(line.split[0], line.split[1].to_i)
end

hands.sort!

winnings = 0
hands.each_with_index do |h, i|
  winnings += h.bid * (i + 1)
end

print winnings, "\n"
