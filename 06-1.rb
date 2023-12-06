#!/usr/bin/env ruby

lines = File.read('06.input').lines.map(&:strip)

times = lines[0].split(':')[1].split.map(&:to_i)
records = lines[1].split(':')[1].split.map(&:to_i)

num = 1
times.each_index do |race|
  time = times[race]
  record = records[race]

  wins = 0
  0.upto(time) do |hold|
    speed = hold
    distance = (time - hold) * speed
    wins += 1 if distance > record
  end
  num *= wins if wins > 0
end

print num, "\n"
