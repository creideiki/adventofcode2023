#!/usr/bin/env ruby

lines = File.read('06.input').lines.map(&:strip)

time = lines[0].split(':')[1].delete(" ").to_i
record = lines[1].split(':')[1].delete(" ").to_i

wins = 0
0.upto(time) do |hold|
  speed = hold
  distance = (time - hold) * speed
  wins += 1 if distance > record
end

print wins, "\n"
