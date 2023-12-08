#!/usr/bin/env ruby

require 'ostruct'

lines = File.read('08.input').lines.map(&:strip)

line_format = /^(?<from>[[:alnum:]]+) = \((?<left>[[:alnum:]]+), (?<right>[[:alnum:]]+)\)$/

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

start_nodes = nodes.keys.select { |k| k.end_with? 'A' }
num_threads = start_nodes.size
steps = [0] * num_threads

num_threads.times do |n|
  ip = 0
  node = start_nodes[n]
  until node.end_with? 'Z'
    node = nodes[node][insns[ip]]
    ip = (ip + 1) % insns.size
    steps[n] += 1
  end
end

print steps.reduce(1, :lcm), "\n"
