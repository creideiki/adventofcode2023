#!/usr/bin/env ruby

lines = File.read('09.input').lines.map(&:strip).map { |l| l.split.map(&:to_i) }

sums = 0
lines.each do |l|
  differences = []
  current_list = l
  current_diff = []
  until !current_diff.empty? and current_diff.all? 0
    current_diff = []
    (current_list.size - 1).times do |n|
      current_diff << current_list[n + 1] - current_list[n]
    end
    current_list = current_diff
    differences << current_diff
  end

  (differences.size - 1).downto(0) do |n|
    differences[n - 1].prepend differences[n - 1][0] - differences[n][0]
  end

  sums += l[0] - differences[0][0]
end

print sums, "\n"
