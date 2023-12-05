#!/usr/bin/env ruby

class Map
  attr_accessor :from, :to, :map, :limits

  def initialize(from, to)
    @from = from
    @to = to
    @map = []
  end

  def add_mapping(first, destination, length)
    @map << {first: first, last: first + length - 1,
             destination: destination, length: length}
    @map.sort_by! { |m| m[:first] }
  end

  def [](input)
    @map.each do |mapping|
      if input >= mapping[:first] and input <= mapping[:last]
        return mapping[:destination] - mapping[:first] + input
      end
    end
    input
  end

  def transform(range)
    ranges = split range
    ranges.map do |r|
      {low: self[r[:low]], high: self[r[:high]]}
    end
  end

  def split(range)
    low = range[:low]
    high = range[:high]
    ranges = []

    @map.each do |mapping|
      next if low > mapping[:last] or high < mapping[:first]

      if low < mapping[:first] and high >= mapping[:first]
        ranges << {low: low, high: mapping[:first] - 1}
        low = mapping[:first]
      end

      if high > mapping[:last]
        ranges << {low: low, high: mapping[:last]}
        low = mapping[:last] + 1
      end
    end

    if high > low
      ranges << {low: low, high: high}
    end

    ranges.sort_by! { |r| r[:low] }
    ranges
  end

  def to_s
    s = "<#{self.class} #{@from}-#{to}: "
    @map.each do |m|
      s += "| #{m[:first]} #{m[:length]} #{m[:destination]} "
    end
    s += ">"
    s
  end
end

input = File.read('05.input').lines.map(&:strip)

ranges = []
maps = []
map = nil

input.each do |line|
  if line.start_with? 'seeds: '
    seed_input = line.split(':')[1].split.map(&:to_i)
    until seed_input.empty?
      first = seed_input.shift
      length = seed_input.shift
      ranges << {low: first, high: first + length - 1}
    end
  elsif line.empty?
    maps << map if map
    map = nil
  elsif line.end_with? 'map:'
    names = line.split[0].split('-')
    map = Map.new(names[0], names[2])
  else
    mapping = line.split.map(&:to_i)
    map.add_mapping(mapping[1], mapping[0], mapping[2])
  end
end
maps << map

final_ranges = []
from = 'seed'
loop do
  next_ranges = []
  map = maps.find { |m| m.from == from }
  to = map.to
  until ranges.empty?
    range = ranges.shift
    next_ranges += map.transform range
  end
  from = to
  next_ranges.sort_by! { |r| r[:low] }
  ranges = next_ranges.uniq
  if to == 'location'
    final_ranges = ranges
    break
  end
end

print final_ranges[0][:low], "\n"
