#!/usr/bin/env ruby

class Map
  attr_accessor :from, :to, :map

  def initialize(from, to)
    @from = from
    @to = to
    @map = []
  end

  def add_mapping(source, destination, length)
    @map << {source: source, destination: destination, length: length}
  end

  def covers?(source, length, test)
    test >= source and test < source + length
  end

  def [](input)
    @map.each do |mapping|
      if covers?(mapping[:source], mapping[:length], input)
        return mapping[:destination] - mapping[:source] + input
      end
    end
    input
  end

  def to_s
    s = "<#{self.class} #{@from}-#{to}: "
    @map.each do |m|
      s += "#{m[:source]} #{m[:length]} #{m[:destination]} "
    end
    s += ">"
    s
  end

end

input = File.read('05.input').lines.map(&:strip)

seeds = nil
maps = []
map = nil

input.each do |line|
  if line.start_with? 'seeds: '
    seeds = line.split(':')[1].split.map(&:to_i)
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

locations = seeds.map do |seed|
  from = 'seed'
  pos = seed
  loop do
    map = maps.find { |m| m.from == from }
    to = map.to
    pos = map[pos]
    break if to == 'location'
    from = to
  end
  pos
end

print locations.min, "\n"
