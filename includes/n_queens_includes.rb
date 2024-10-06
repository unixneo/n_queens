

def get_number_of_queens
  queens = $number_of_queens
  ARGV.each do |argv|
    # Usage:   ruby n_queens.rb 10
    queens = argv.to_i
    if queens.between?(1,$max_queens)
      queens
    else
      puts "Max Queens is set to #{$max_queens} but you requested #{queens} Queens!\n" 
      exit
    end
  end
  queens
end


# Turn Seconds into Human-Readable Time with Ruby
  def human_readable_time(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
      next unless secs > 0
  
      secs, number = secs.divmod(count)
      "#{number.to_i} #{number == 1 ? name.to_s.delete_suffix('s') : name}" unless number.to_i == 0
    end.compact.reverse.join(', ')
  end

  def format_time(start_time)
    time = Time.now - start_time
    str_time = ''
    if time > 100
        str_time = human_readable_time(time.round(6))
    else
        str_time = "#{time}s"
    end
    str_time
  end
  
  # Function to generate queen's movement array for each position on an NxN board
  def generate_queen_moves(row, col)
    board_size = $number_of_queens
    moves = Array.new(board_size * board_size, 0)
  
    # Mark all positions in the same row
    (0...board_size).each { |c| moves[row * board_size + c] = 1 }
  
    # Mark all positions in the same column
    (0...board_size).each { |r| moves[r * board_size + col] = 1 }
  
    # Mark top-left to bottom-right diagonal
    (-[row, col].min..[board_size - 1 - row, board_size - 1 - col].min).each do |i|
      moves[(row + i) * board_size + (col + i)] = 1
    end
  
    # Mark top-right to bottom-left diagonal
    (-[row, board_size - 1 - col].min..[board_size - 1 - row, col].min).each do |i|
      moves[(row + i) * board_size + (col - i)] = 1
    end
  
    moves
  end
  
  # Function to generate the entire hash of queen moves for all positions on an NxN board
  def generate_queen_moves_for_n_queens
    queen_moves = {}
    board_size = $number_of_queens
    (0...board_size).each do |row|
      (0...board_size).each do |col|
        pos = row * board_size + col
        queen_moves["Position #{pos}"] = generate_queen_moves(row, col)
      end
    end
    queen_moves
  end
  
  # Function to check if placing a queen at the current position is safe
  def is_safe(position, queens, queen_moves)
    queens.each do |q|
      # Check for conflicts in movement based on queen's attackable positions
      return false if queen_moves["Position #{q}"][position] == 1
    end
    true
  end
  
  # Recursive function to solve the n-queens problem
  def solve_n_queens(queen_moves, queens = [], row = 0, solutions = [])
    board_size = $number_of_queens
    if queens.size == board_size  # All queens placed
      solutions << queens.dup  # Store the solution
      return
    end
  
    (0...board_size).each do |col|  # Loop through all columns
      position = row * board_size + col  # Calculate position based on row and column
      if is_safe(position, queens, queen_moves)
        queens.push(position)  # Place the queen
        solve_n_queens(queen_moves, queens, row + 1, solutions)
        queens.pop  # Backtrack
      end
    end
  
    solutions
  end
