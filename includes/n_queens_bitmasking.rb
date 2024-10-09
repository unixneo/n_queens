require 'parallel'


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
def solve_n_queens_bitmask_parallel(board_size,number_of_processors)
  solutions = Parallel.map(0...board_size, in_processes: number_of_processors) do |col|
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

$prior_elasped_time = 0
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

    if $show_elasped_time
      elasped_time = Time.now - $start_time
      if (elasped_time % $modulo_time == 0) 
        puts "#{Time.now} >>> Elasped Time is #{elasped_time} second\n"
      end
    end
    

    # Calculate column number (bit index)
    col = Math.log2(position).to_i
   
    # Place queen and update the board status
    queens.push(col)
   
    place_queen_bitmask_parallel(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, queens, all_columns, board_size, solutions)
    
    
    queens.pop  # Backtrack
  end
end