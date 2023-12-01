#!/usr/bin/env ruby

lines = File.read('01.input').lines.map(&:strip)

print(lines.map do |line|
  numerals = line.chars.reject { |c| c.match('[[:alpha:]]') }
  (numerals[0] + numerals[-1]).to_i
end.sum, "\n")
