#!/usr/bin/env ruby

input = File.read('10.input').lines.map(&:strip).map(&:chars)
height = input.size
width = input[0].size

distances = Array.new height
distances = distances.map { |_| Array.new(width, -1) }

pipes = Array.new height
pipes = pipes.map { |_| Array.new width }

start_y = -1
start_x = -1
height.times do |y|
  width.times do |x|
    pipes[y][x] = case input[y][x]
                  when 'S'
                    distances[y][x] = 0
                    start_y = y
                    start_x = x
                    []
                  when '.'
                    []
                  when '|'
                    [:north, :south]
                  when '-'
                    [:east, :west]
                  when 'L'
                    [:north, :east]
                  when 'J'
                    [:north, :west]
                  when '7'
                    [:south, :west]
                  when 'F'
                    [:south, :east]
                  end
  end
end

if start_y >= 1 and pipes[start_y - 1][start_x].include? :south
  pipes[start_y][start_x] << :north
end
if start_y < height - 1 and pipes[start_y + 1][start_x].include? :north
  pipes[start_y][start_x] << :south
end
if start_x >= 1 and pipes[start_y][start_x - 1].include? :east
  pipes[start_y][start_x] << :west
end
if start_x < width - 1 and pipes[start_y][start_x + 1].include? :west
  pipes[start_y][start_x] << :east
end

cur_dist = -1
cur_y = start_y
cur_x = start_x
from = nil

loop do
  cur_dist = distances[cur_y][cur_x]
  if from != :north and cur_y > 0 and pipes[cur_y][cur_x].include? :north and pipes[cur_y - 1][cur_x].include? :south
    distances[cur_y - 1][cur_x] = cur_dist + 1 unless distances[cur_y - 1][cur_x] == 0
    from = :south
    cur_y -= 1
  elsif from != :east and cur_x < width - 1 and pipes[cur_y][cur_x].include? :east and pipes[cur_y][cur_x + 1].include? :west
    distances[cur_y][cur_x + 1] = cur_dist + 1 unless distances[cur_y - 1][cur_x] == 0
    from = :west
    cur_x += 1
  elsif from != :south and cur_y < height - 1 and pipes[cur_y][cur_x].include? :south and pipes[cur_y + 1][cur_x].include? :north
    distances[cur_y + 1][cur_x] = cur_dist + 1 unless distances[cur_y - 1][cur_x] == 0
    from = :north
    cur_y += 1
  elsif from != :west and cur_x > 0 and pipes[cur_y][cur_x].include? :west and pipes[cur_y][cur_x - 1].include? :east
    distances[cur_y][cur_x - 1] = cur_dist + 1 unless distances[cur_y - 1][cur_x] == 0
    from = :east
    cur_x -= 1
  end

  break if cur_y == start_y and cur_x == start_x
end

print (cur_dist + 1) / 2, "\n"
