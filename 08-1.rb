#!/usr/bin/env ruby

require 'ostruct'

lines = File.read('08.input').lines.map(&:strip)

line_format = /^(?<from>[[:alpha:]]+) = \((?<left>[[:alpha:]]+), (?<right>[[:alpha:]]+)\)$/

insns = lines[0].chars.map do |i|
  if i == 'L'
    'left'
  else
    'right'
  end
end

nodes = {}

lines[2..].each do |line|
  m = line.match line_format
  nodes[m['from']] = OpenStruct.new({ left: m['left'], right: m['right'] })
end

node = 'AAA'
ip = 0
steps = 0
until node == 'ZZZ'
  node = nodes[node][insns[ip]]
  ip = (ip + 1) % insns.size
  steps += 1
end

print steps, "\n"
