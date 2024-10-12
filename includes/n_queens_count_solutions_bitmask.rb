require 'parallel'

# ================================
# Optimized Bitmasking Solution with Progress Output
# ================================
def count_n_queens_solutions_bitmask(board_size)
  all_columns = (1 << board_size) - 1  # Create a bitmask for all available columns
  $total_solution_count = 0  # Global counter for solutions
  $start_time = Time.now  # Start timer for elapsed time tracking

  # Call the recursive function and return the final solution count
  solution_count = count_queen_solutions_bitmask(0, 0, 0, 0, all_columns, board_size)
  solution_count
end

# Helper function for bitmask solution
def count_queen_solutions_bitmask(row, cols, diags1, diags2, all_columns, board_size)
  return 1 if cols == all_columns  # All queens are placed, count 1 solution

  # Available positions are those not under attack
  available_positions = all_columns & ~(cols | diags1 | diags2)

  solution_count = 0
  while available_positions != 0
    # Pick the rightmost available position
    position = available_positions & -available_positions
    available_positions -= position

    # Recurse to place queen in the next row
    solution_count += count_queen_solutions_bitmask(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, all_columns, board_size)
    
    # Increment the global solution count
    $total_solution_count += 1
    if ($total_solution_count % 1_000_000_000).zero?
      elapsed_time = Time.now - $start_time
      log_message("PID: #{Process.pid} Solutions: #{human_readable_number($total_solution_count)}. Elapsed time: #{human_readable_time(elapsed_time)}.")
    end
  end

  return solution_count
end

# ================================
# Parallel Execution with Bitmasking and Progress Output
# ================================
def count_n_queens_solutions_parallel(board_size, number_of_processors)
  $total_solution_count = 0  # Global counter for solutions
  $start_time = Time.now  # Start the timer

  # Parallelize across columns, each process logging its progress independently
  solution_counts = Parallel.map(0...board_size, in_processes: number_of_processors) do |col|
    count_solutions_single_column_bitmask(col, board_size)
  end

  # Sum the results returned by each process
  solution_counts.sum
end

# Solve for a single column using the bitmasking approach (for parallel execution)
def count_solutions_single_column_bitmask(col, board_size)
  all_columns = (1 << board_size) - 1  # Create a bitmask for all available columns

  # Initialize bitmask states and place the queen in the first row at column `col`
  initial_position = 1 << col
  count_queen_solutions_parallel(1, initial_position, initial_position << 1, initial_position >> 1, all_columns, board_size)
end

# Recursive bitmask method for placing queens, optimized for parallel execution
def count_queen_solutions_parallel(row, cols, diags1, diags2, all_columns, board_size)
  return 1 if cols == all_columns  # All queens are placed, count 1 solution

  # Available positions are those not under attack
  available_positions = all_columns & ~(cols | diags1 | diags2)

  solution_count = 0
  while available_positions != 0
    # Pick the rightmost available position
    position = available_positions & -available_positions
    available_positions -= position

    # Recurse to place queen in the next row
    solution_count += count_queen_solutions_parallel(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, all_columns, board_size)

    # Increment and print message every 100,000,000 solutions
    $total_solution_count += 1
    if ($total_solution_count % 1_000_000_000).zero?
      elapsed_time = Time.now - $start_time
      log_message("PID: #{Process.pid} Solutions: #{human_readable_number($total_solution_count)}. Elapsed time: #{human_readable_time(elapsed_time)}.")
    end
  end

  return solution_count
end

# ================================
# Helper methods
# ================================

# Helper method to format large numbers
def human_readable_number(number)
  units = [' ', 'thousand', 'million', 'billion', 'trillion']
  unit = 0
  while number >= 1000 && unit < units.size - 1
    number /= 1000.0
    unit += 1
  end
  "#{number.round(2)} #{units[unit]}"
end

# Helper method to format elapsed time in hours, minutes, and seconds
def human_readable_time(seconds)
  [[60, :seconds], [60, :minutes], [24, :hours]].map do |count, name|
    next unless seconds > 0
    seconds, number = seconds.divmod(count)
    "#{number.to_i} #{name}" unless number.to_i.zero?
  end.compact.reverse.join(', ')
end

# Helper method to log messages
def log_message(message)
  puts "#{Time.now} >>> #{message}"
end
