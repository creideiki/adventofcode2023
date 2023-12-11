#!/usr/bin/env ruby

class Map
  attr_accessor :input, :distances, :pipes, :start_x, :start_y, :exp_pipes

  def initialize(input)
    @input = input

    @height = @input.size
    @width = @input[0].size

    @distances = Array.new @height
    @distances = @distances.map { |_| Array.new(@width, -1) }

    @pipes = Array.new @height
    @pipes = @pipes.map { |_| Array.new @width }

    @start_y = -1
    @start_x = -1
  end

  def parse_pipes!
    @height.times do |y|
      @width.times do |x|
        @pipes[y][x] = case @input[y][x]
                       when 'S'
                         @distances[y][x] = 0
                         @start_y = y
                         @start_x = x
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

    if @start_y >= 1 and @pipes[@start_y - 1][@start_x].include? :south
      @pipes[@start_y][@start_x] << :north
    end
    if @start_y < @height - 1 and @pipes[@start_y + 1][@start_x].include? :north
      @pipes[@start_y][@start_x] << :south
    end
    if @start_x >= 1 and @pipes[@start_y][@start_x - 1].include? :east
      @pipes[@start_y][@start_x] << :west
    end
    if @start_x < @width - 1 and @pipes[@start_y][@start_x + 1].include? :west
      @pipes[@start_y][@start_x] << :east
    end
  end

  def measure_loop!
    cur_dist = -1
    cur_y = @start_y
    cur_x = @start_x
    from = nil

    loop do
      cur_dist = @distances[cur_y][cur_x]
      if from != :north and cur_y > 0 and @pipes[cur_y][cur_x].include? :north and @pipes[cur_y - 1][cur_x].include? :south
        @distances[cur_y - 1][cur_x] = cur_dist + 1 unless @distances[cur_y - 1][cur_x] == 0
        from = :south
        cur_y -= 1
      elsif from != :east and cur_x < @width - 1 and @pipes[cur_y][cur_x].include? :east and @pipes[cur_y][cur_x + 1].include? :west
        @distances[cur_y][cur_x + 1] = cur_dist + 1 unless @distances[cur_y - 1][cur_x] == 0
        from = :west
        cur_x += 1
      elsif from != :south and cur_y < @height - 1 and @pipes[cur_y][cur_x].include? :south and @pipes[cur_y + 1][cur_x].include? :north
        @distances[cur_y + 1][cur_x] = cur_dist + 1 unless @distances[cur_y - 1][cur_x] == 0
        from = :north
        cur_y += 1
      elsif from != :west and cur_x > 0 and @pipes[cur_y][cur_x].include? :west and @pipes[cur_y][cur_x - 1].include? :east
        @distances[cur_y][cur_x - 1] = cur_dist + 1 unless @distances[cur_y - 1][cur_x] == 0
        from = :east
        cur_x -= 1
      end

      break if cur_y == @start_y and cur_x == @start_x
    end

    return (cur_dist + 1) / 2
  end

  def expand!
    @exp_pipes = Array.new(@height * 3 + 2)
    @exp_pipes = @exp_pipes.map { |_| Array.new(@width * 3 + 2, 0)}

    @height.times do |y|
      @width.times do |x|
        if @distances[y][x] >= 0
          @exp_pipes[1 + y * 3 + 2][1 + x * 3 + 2] = 1
          @exp_pipes[1 + y * 3 + 1][1 + x * 3 + 2] = 1 if @pipes[y][x].include? :north
          @exp_pipes[1 + y * 3 + 2][1 + x * 3 + 3] = 1 if @pipes[y][x].include? :east
          @exp_pipes[1 + y * 3 + 3][1 + x * 3 + 2] = 1 if @pipes[y][x].include? :south
          @exp_pipes[1 + y * 3 + 2][1 + x * 3 + 1] = 1 if @pipes[y][x].include? :west
        end
      end
    end
  end

  def expanded_flood_fill!(y, x, n)
    queue = [[y, x]]
    until queue.empty?
      cell = queue.shift
      next if @exp_pipes[cell[0]][cell[1]] != 0

      @exp_pipes[cell[0]][cell[1]] = n
      queue << [cell[0] - 1, cell[1]] if cell[0] > 0 and @exp_pipes[cell[0] - 1][cell[1]].zero?
      queue << [cell[0] + 1, cell[1]] if cell[0] < (@height * 3 + 2) - 1 and @exp_pipes[cell[0] + 1][cell[1]].zero?
      queue << [cell[0], cell[1] - 1] if cell[1] > 0 and @exp_pipes[cell[0]][cell[1] - 1].zero?
      queue << [cell[0], cell[1] + 1] if cell[1] < (@width * 3 + 2) - 1 and @exp_pipes[cell[0]][cell[1] + 1].zero?
    end
  end

  def count_inside
    count = 0
    @height.times do |y|
      @width.times do |x|
        pipe = false
        0.upto(2) do |dy|
          0.upto(2) do |dx|
            if @exp_pipes[1 + y * 3 + dy][1 + x * 3 + dx] != 0
              pipe = true
              break
            end
          end
        end
        count += 1 unless pipe
      end
    end
    count
  end

  def to_s
    s = "<#{self.class}:\n"
    (@height * 3 + 2).times do |y|
      (@width * 3 + 2).times do |x|
        s += @exp_pipes[y][x].to_s
      end
      s += "\n"
    end
    s += ">"
  end
end

input = File.read('10.input').lines.map(&:strip).map(&:chars)
map = Map.new(input)
map.parse_pipes!
map.measure_loop!
map.expand!
map.expanded_flood_fill!(0, 0, 2)
print map.count_inside, "\n"
