require 'parallel'

# Get the number of queens from the command-line argument or default
def get_number_of_queens(max_queens)
  queens = $number_of_queens
  ARGV.each do |argv|
    queens = argv.delete('^0-9').to_i
    if queens.between?(1, max_queens)
      return queens
    else
      puts "Max Queens is set to #{max_queens} but you requested #{queens} queens!"
      exit
    end
  end
  queens
end

# Turn seconds into a human-readable format
def human_readable_time(secs)
  [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
    next unless secs > 0

    secs, number = secs.divmod(count)
    "#{number.to_i} #{number == 1 ? name.to_s.delete_suffix('s') : name}" unless number.to_i.zero?
  end.compact.reverse.join(', ')
end

# Format the time since start_time in a readable format
def format_time(start_time)
  time = Time.now - start_time
  if time > 100
    human_readable_time(time.round(6))
  else
    "#{time.round(6)} seconds"
  end
end

# ================================
# Standard Backtracking with Pruning
# ================================
def solve_n_queens_fast(board_size)
  solutions = []
  columns = Array.new(board_size, false)
  main_diag = Array.new(2 * board_size - 1, false)  # Main diagonals (row - col)
  anti_diag = Array.new(2 * board_size - 1, false)  # Anti-diagonals (row + col)

  place_queen(0, [], board_size, columns, main_diag, anti_diag, solutions)
  solutions
end

# Helper function for standard backtracking to place queens
def place_queen(row, queens, board_size, columns, main_diag, anti_diag, solutions)
  if row == board_size
    solutions << queens.dup
    return
  end

  board_size.times do |col|
    if !columns[col] && !main_diag[row - col + board_size - 1] && !anti_diag[row + col]
      # Mark this column and diagonals as occupied
      columns[col] = main_diag[row - col + board_size - 1] = anti_diag[row + col] = true
      queens.push(col)

      place_queen(row + 1, queens, board_size, columns, main_diag, anti_diag, solutions)

      # Backtrack and unmark the column and diagonals
      columns[col] = main_diag[row - col + board_size - 1] = anti_diag[row + col] = false
      queens.pop
    end
  end
end

# ================================
# Optimized Bitmasking Solution
# ================================
def solve_n_queens_bitmask(board_size)
  solutions = []
  all_columns = (1 << board_size) - 1  # Create a bitmask for all available columns

  place_queen_bitmask(0, 0, 0, 0, [], all_columns, board_size, solutions)
  solutions
end

# Helper function for bitmask solution
def place_queen_bitmask(row, cols, diags1, diags2, queens, all_columns, board_size, solutions)
  if cols == all_columns  # All queens are placed
    solutions << queens.dup
    return
  end

  # Available positions are those not under attack
  available_positions = all_columns & ~(cols | diags1 | diags2)

  while available_positions != 0
    # Pick the rightmost available position
    position = available_positions & -available_positions
    available_positions -= position

    # Calculate column number (bit index)
    col = Math.log2(position).to_i

    # Place queen and update the board status
    queens.push(col)
    place_queen_bitmask(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, queens, all_columns, board_size, solutions)
    queens.pop  # Backtrack
  end
end

# ================================
# Parallel Execution with Bitmasking
# ================================
def solve_n_queens_bitmask_parallel(board_size)
  solutions = Parallel.map(0...board_size, in_threads: board_size) do |col|
    solve_single_column_with_bitmask(col, board_size)
  end

  solutions.flatten(1)
end

# Solve for a single column using the bitmasking approach (for parallel execution)
def solve_single_column_with_bitmask(col, board_size)
  solutions = []
  all_columns = (1 << board_size) - 1  # Create a bitmask for all available columns

  # Initialize bitmask states and place the queen in the first row at column `col`
  initial_position = 1 << col
  place_queen_bitmask_parallel(1, initial_position, initial_position << 1, initial_position >> 1, [col], all_columns, board_size, solutions)

  solutions
end

# Recursive bitmask method for placing queens, optimized for parallel execution
def place_queen_bitmask_parallel(row, cols, diags1, diags2, queens, all_columns, board_size, solutions)
  if cols == all_columns  # All queens are placed
    solutions << queens.dup
    return
  end

  # Available positions are those not under attack
  available_positions = all_columns & ~(cols | diags1 | diags2)

  while available_positions != 0
    # Pick the rightmost available position
    position = available_positions & -available_positions
    available_positions -= position

    # Calculate column number (bit index)
    col = Math.log2(position).to_i

    # Place queen and update the board status
    queens.push(col)
    place_queen_bitmask_parallel(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, queens, all_columns, board_size, solutions)
    queens.pop  # Backtrack
  end
end