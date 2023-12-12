#!/usr/bin/env ruby

class Springs
  attr_accessor :row, :groupings

  def initialize(line)
    row, groupings = line.split
    @row = row.chars
    @groupings = groupings.split(',').map(&:to_i)
  end

  def possible?(row)
    groups = []
    in_group = false
    cur_group = 0
    row.each_index do |n|
      case row[n]
      when '?'
        return true
      when '.'
        in_group = false
        if cur_group > 0
          groups << cur_group
          cur_group = 0
          return false unless groups[groups.size - 1] == @groupings[groups.size - 1]
        end
      when '#'
        cur_group = 0 unless in_group
        in_group = true
        cur_group += 1
      end
    end
    groups << cur_group if cur_group > 0

    if groups[groups.size - 1] != @groupings[groups.size - 1] or
      groups.size != @groupings.size
      return false
    end

    true
  end

  def possibilities
    queue = [@row.dup]
    definite = []

    until queue.empty?
      p = queue.shift
      next unless possible?(p)

      next_unknown = p.index '?'
      if next_unknown
        temp = p.dup
        temp[next_unknown] = '.'
        queue << temp

        temp = p.dup
        temp[next_unknown] = '#'
        queue << temp
      else
        definite << p
      end
    end

    definite
  end

  def inspect
    to_s
  end

  def to_s
    "<#{self.class}: #{@row.join} #{@groupings.join}>"
  end
end

input = File.read('12.input').lines.map(&:strip)

springs = input.map { |l| Springs.new(l) }
print springs.sum { |s| s.possibilities.size }, "\n"
