#!/usr/bin/env ruby

require 'memoist'

class Springs
  extend Memoist

  attr_accessor :row, :groupings

  def initialize(line)
    row, groupings = line.split
    @row = ([row] * 5).join('?').chars
    @groupings = groupings.split(',').map(&:to_i) * 5
  end

  def possibilities
    count_possibilities(@row, @groupings, 0)
  end

  def count_possibilities(row, groupings, current_group_size)
    if row.empty?
      if groupings.empty? or
         (groupings.size == 1 and groupings[0] == current_group_size)
        return 1
      else
        return 0
      end
    end

    arrangements = 0
    cases = if row[0] == '?'
              ['#', '.']
            else
              [row[0]]
            end
    cases.each do |c|
      case c
      when '#'
        arrangements += count_possibilities(row[1..], groupings, current_group_size + 1) unless groupings.empty?
      when '.'
        if current_group_size == groupings[0]
          arrangements += count_possibilities(row[1..], groupings[1..], 0)
        elsif current_group_size.zero?
          arrangements += count_possibilities(row[1..], groupings, 0)
        end
      end
    end
    arrangements
  end

  memoize :count_possibilities

  def inspect
    to_s
  end

  def to_s
    "<#{self.class}: #{@row.join} #{@groupings.join}>"
  end
end

input = File.read('12.input').lines.map(&:strip)

springs = input.map { |l| Springs.new(l) }
print springs.sum(&:possibilities), "\n"
