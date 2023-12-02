#!/usr/bin/env ruby

lines = File.read('02.input').lines.map(&:strip)

line_format = /^Game (?<num>[[:digit:]]+): (?<reveals>.*)$/

games = {}

lines.each do |line|
  m = line.match line_format
  games[m['num'].to_i] = []
  reveals = m['reveals'].split ';'
  reveals.each do |reveal|
    colours = {
      'red' => 0,
      'green' => 0,
      'blue' => 0
    }
    tokens = reveal.delete(',').split
    until tokens.empty?
      num = tokens.shift.to_i
      colour = tokens.shift
      colours[colour] = num
    end
    games[m['num'].to_i] << colours
  end
end

def possible?(game)
  allowed = {
    'red' => 12,
    'green' => 13,
    'blue' => 14
  }
  game.each do |reveal|
    ['red', 'green', 'blue'].each do |colour|
      return false if reveal[colour] > allowed[colour]
    end
  end
  true
end

print games.select { |_, game| possible? game }.keys.sum
print "\n"
