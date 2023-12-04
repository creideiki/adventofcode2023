#!/usr/bin/env ruby

require 'ostruct'

lines = File.read('04.input').lines.map(&:strip)

card_format = /^Card +(?<num>[[:digit:]]+): (?<winning>[[:digit:] ]*)\|(?<have>[[:digit:] ]*)$/

cards = [OpenStruct.new({ wins: 0, copies: 0 })]

lines.each do |line|
  m = line.match card_format
  winning = m['winning'].split.map(&:to_i)
  have = m['have'].split.map(&:to_i)
  cards << OpenStruct.new({ wins: (winning & have).size, copies: 1})
end

cards.each_index do |card_num|
  cards[card_num].wins.times do |n|
    cards[card_num + n + 1].copies += cards[card_num].copies
  end
end

print cards.sum(&:copies), "\n"
