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
  @@card_order = ['J', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A']

  def classify
    non_jokers = cards.select { |c| c != 'J' }.sort
    num_jokers = cards.count { |c| c == 'J' }

    case num_jokers
    when 5
      :five
    when 4
      :five
    when 3
      if non_jokers[0] == non_jokers[1]
        :five
      else
        :four
      end
    when 2
      if non_jokers[0] == non_jokers[1] and non_jokers[1] == non_jokers[2]
        :five
      elsif non_jokers[0] == non_jokers[1] or non_jokers[1] == non_jokers[2]
        :four
      else
        :three
      end
    when 1
      if non_jokers.all? { |c| c == non_jokers[0] }
        :five
      elsif non_jokers[0..2].all? { |c| c == non_jokers[0] } or
           non_jokers[1..3].all? { |c| c == non_jokers[1] }
        :four
      elsif non_jokers[0] == non_jokers[1] and non_jokers[2] == non_jokers[3]
        :full_house
      elsif non_jokers[0] == non_jokers[1] or
           non_jokers[1] == non_jokers[2] or
           non_jokers[2] == non_jokers[3]
        :three
      else
        :one_pair
      end
    when 0
      if non_jokers.all? { |c| c == non_jokers[0] }
        :five
      elsif non_jokers[0..-2].all? { |c| c == non_jokers[0] } or
           non_jokers[1..-1].all? { |c| c == non_jokers[1] }
        :four
      elsif (non_jokers[0] == non_jokers[1] and non_jokers[2] == non_jokers[3] and non_jokers[3] == non_jokers[4]) or
           (non_jokers[0] == non_jokers[1] and non_jokers[1] == non_jokers[2] and non_jokers[3] == non_jokers[4])
        :full_house
      elsif non_jokers[0..-3].all? { |c| c == non_jokers[0] } or
           non_jokers[1..-2].all? { |c| c == non_jokers[1] } or
           non_jokers[2..-1].all? { |c| c == non_jokers[2] }
        :three
      elsif (non_jokers[0] == non_jokers[1] and non_jokers[2] == non_jokers[3]) or
           (non_jokers[0] == non_jokers[1] and non_jokers[3] == non_jokers[4]) or
           (non_jokers[1] == non_jokers[2] and non_jokers[3] == non_jokers[4])
        :two_pair
      elsif non_jokers[0] == non_jokers[1] or
           non_jokers[1] == non_jokers[2] or
           non_jokers[2] == non_jokers[3] or
           non_jokers[3] == non_jokers[4]
        :one_pair
      else
        :card
      end
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
