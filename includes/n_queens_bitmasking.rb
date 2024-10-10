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
    
   
    collect_garbage_and_print if $show_elapsed_time

    # Calculate column number (bit index)
    col = Math.log2(position).to_i
   
    # Place queen and update the board status
    queens.push(col)
   
    place_queen_bitmask_parallel(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, queens, all_columns, board_size, solutions)
    
    
    queens.pop  # Backtrack
  end
end

# puts human_readable_number(1000000000)  # Output: 1.0 billion
def collect_garbage_and_print
  $line_count += 1
  elasped_time = Time.now - $start_time  # Calculate elapsed time once

  # Only trigger the log and GC every 100,000,000 iterations
  if ($line_count % 100_000_000).zero?
    # Trigger garbage collection if the flag is set
    if $collect_garbage
      GC.start 
      puts "#{Time.now} >>> GC for PID #{Process.pid} @ Count #{human_readable_number($line_count)} Elapsed Time: #{human_readable_time(elasped_time)}\n"
    else
      puts "#{Time.now} >>> PID #{Process.pid} @ Count #{human_readable_number($line_count)} Elapsed Time: #{human_readable_time(elasped_time)}\n"
    end
  end
end

# Turn seconds into a human-readable format
def human_readable_time(secs)
  [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
    next unless secs > 0

    secs, number = secs.divmod(count)
    "#{number.to_i} #{number == 1 ? name.to_s.delete_suffix('s') : name}" unless number.to_i.zero?
  end.compact.reverse.join(', ')
end

# Example usage: puts human_readable_number(1000000000)  # Output: 1.0 billion
def human_readable_number(number)
  units = [' ', 'thousand', 'million', 'billion', 'trillion', 'quadrillion', 'quintillion']
  unit = 0

  while number >= 1000 && unit < units.size - 1
    number /= 1000.0
    unit += 1
  end

  "#{number.round(2)} #{units[unit]}"
end


