class QueenSolver

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @stack = [Queen.new(0,rand(0..7))] 
    @board[0][@stack[0].column] = @stack[0]
    place_next_queen(1)
  end

  def place_next_queen(row)
    @stack << Queen.new(row, 0)
    if find_safe_square
      return solution_render if row + 1 == 8
      place_next_queen(row + 1)
    else
      backtrack
    end
  end
  
  def backtrack
    @stack.pop
    increment_current_column
  end

  def increment_current_column
    q = current
    @board[q.row][q.column] = nil
    q.column += 1 
    while q.column < 8
      if !queens_attacking?(q.row, q.column)
        @board[q.row][q.column] = q
        return place_next_queen(q.row + 1)
      end
      q.column += 1
    end
    backtrack
  end
  
  def find_safe_square
    q = current
    @board[q.row].each_with_index do |sq, i|
      if !queens_attacking?(q.row, i)
        @board[q.row][i] = q
        q.column = i
        return true
      end
    end
    false
  end

  def queens_attacking?(row, col)
    return true if queens.any? {|q| q.row == row}
    return true if queens.any? {|q| q.column == col}
    return true if queens.any? {|q| q.row - q.column == row - col}
    return true if queens.any? {|q| q.row + q.column == row + col}
    false
  end

  def queens
    @board.flatten.select {|e| e.is_a?(Queen)}
  end

  def current
    @stack.last
  end

  def render
    @board.each do |row|
      puts row.map {|e| e.is_a?(Queen) ? 'Q' : '-'}.join(" ")
    end
  end

  def solution_render
    puts "SOLUTION"
    render
    puts "wow"
  end

end

class Queen
  attr_accessor :column
  attr_reader :row
  def initialize(row, col)
    @row, @column = row, col
  end
end

QueenSolver.new
