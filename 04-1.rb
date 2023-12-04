#!/usr/bin/env ruby

lines = File.read('04.input').lines.map(&:strip)

card_format = /^Card +(?<num>[[:digit:]]+): (?<winning>[[:digit:] ]*)\|(?<have>[[:digit:] ]*)$/

score = lines.sum do |line|
  m = line.match card_format
  winning = m['winning'].split.map(&:to_i)
  have = m['have'].split.map(&:to_i)
  if (winning & have).size > 0
    2 ** ((winning & have).size - 1)
  else
    0
  end
end

print score, "\n"
