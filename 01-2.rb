#!/usr/bin/env ruby

lines = File.read('01.input').lines.map(&:strip)

$numeral_pattern = /[[:digit:]]|one|two|three|four|five|six|seven|eight|nine/

def name_to_numeral(name)
  case name
  when /[[:digit:]]/
    name
  when 'one'
    '1'
  when 'two'
    '2'
  when 'three'
    '3'
  when 'four'
    '4'
  when 'five'
    '5'
  when 'six'
    '6'
  when 'seven'
    '7'
  when 'eight'
    '8'
  when 'nine'
    '9'
  end
end

def scan_string(s)
  if s.nil? or s.empty?
    []
  elsif s.start_with? $numeral_pattern
    [s.match($numeral_pattern).to_s] + scan_string(s[1..])
  else
    scan_string s[1..]
  end
end

print(lines.map do |line|
  numerals = scan_string line
  (name_to_numeral(numerals[0]) + name_to_numeral(numerals[-1])).to_i
end .sum, "\n")
