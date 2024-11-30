require 'parallel'
require 'fileutils'

# ================================
# Optimized Bitmasking Solution (writing to disk in batches)
# ================================
$solution_count_per_process = 0

def solve_n_queens_bitmask_parallel_to_file(board_size, number_of_processors)
  solution_count_per_process = 0
  log_message("Starting parallel processing for N=#{board_size} with #{number_of_processors} processors")
  $start_time = Time.now
  $solutions_count = 0

  timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
  $dir_name = "solutions_#{board_size}_#{timestamp}"
  log_message("Directory Name: #{$dir_name}")
  FileUtils.mkdir_p($dir_name)


  Parallel.each(0...board_size, in_processes: number_of_processors) do |col|
    filename = "n_queens_solutions_#{board_size}_col_#{col}.txt"
   
    File.open("./#{$dir_name}/#{filename}", 'w') do |file|
      solve_single_column_bitmask_to_file(col, board_size, file, solution_count_per_process)
    end
  end
end

# Solve for a single column using the bitmasking approach (for parallel execution, buffered writing to file)
def solve_single_column_bitmask_to_file(col, board_size, file,solution_count_per_process)
  count = 0
  all_columns = (1 << board_size) - 1  # Create a bitmask for all available columns
  initial_position = 1 << col
  buffer = []  # Buffer to hold solutions before writing to file

  place_queen_bitmask_to_file(1, initial_position, initial_position << 1, initial_position >> 1, [col], all_columns, board_size, file, buffer)

  # Ensure all remaining solutions are written to file before process exits
  count = write_solutions_to_file(buffer, file) unless buffer.empty?
  solution_count_per_process += count
  file.puts(solution_count_per_process)
  file.flush

end

# Recursive bitmask method for placing queens, optimized for parallel execution and buffered writing to file
def place_queen_bitmask_to_file(row, cols, diags1, diags2, queens, all_columns, board_size, file, buffer)
  if cols == all_columns  # All queens are placed
    buffer << queens.dup  # Store solution in the buffer
    $solutions_count += 1
    collect_garbage_and_log(file, buffer)  # Periodically write solutions and collect garbage
    return
  end

  available_positions = all_columns & ~(cols | diags1 | diags2)

  while available_positions != 0
    position = available_positions & -available_positions
    available_positions -= position

    col = Math.log2(position).to_i
    queens.push(col)

    place_queen_bitmask_to_file(row + 1, cols | position, (diags1 | position) << 1, (diags2 | position) >> 1, queens, all_columns, board_size, file, buffer)

    queens.pop  # Backtrack
  end
end

# Collect garbage and log progress periodically; write solutions to file in batches
def collect_garbage_and_log(file, buffer)
  count = 0

if COUNT_SOLUTIONS_ONLY
  if $solutions_count % 100_000 == 0  # Adjust the batch size as needed
    # report = MemoryProfiler.report do
    #   Parallel.each(large_array, in_processes: 4) { |element| process_element(element) }
    # end
    
    # report.pretty_print
    GC.start
  end

  if $solutions_count % 1_000_000 == 0
    elapsed_time = Time.now - $start_time
    log_message("GC for PID #{Process.pid} @ Solution Count: #{human_readable_number($solutions_count)}, Elapsed: #{human_readable_time(elapsed_time)}")
  end

  if $solutions_count % 10_000_000 == 0
    system("clear")
  end
end

  if DO_NOT_COUNT_SOLUTIONS_ONLY  && $solutions_count % 1_000_000 == 0  # Adjust the batch size as needed
    # Write buffered solutions to file and clear buffer
    count = write_solutions_to_file(buffer, file) unless buffer.empty?
    $solution_count_per_process += count
    buffer.clear

    # Trigger garbage collection if the flag is set
    GC.start
    elapsed_time = Time.now - $start_time
    log_message("GC for PID #{Process.pid} @ Solution Count: #{human_readable_number($solutions_count)}, #{human_readable_number($solution_count_per_process)} Elapsed: #{human_readable_time(elapsed_time)}")
  end
end

# Write solutions from buffer to file
def write_solutions_to_file(buffer, file)
  total_count_per_process = 0
  if DO_NOT_COUNT_SOLUTIONS_ONLY  && $number_of_queens < 20
    buffer.each do |solution|
      file.puts(solution.join(','))
    end
  end
  total_count_per_process = buffer.nil? ? 0 : buffer.count
  buffer.clear
  total_count_per_process
end

# Helper method for logging progress
def log_message(message)
  puts "#{Time.now} >>> #{message}"
end

# Turn seconds into a human-readable format
def human_readable_time(secs)
  [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
    next unless secs > 0

    secs, number = secs.divmod(count)
    "#{number.to_i} #{number == 1 ? name.to_s.delete_suffix('s') : name}" unless number.to_i.zero?
  end.compact.reverse.join(', ')
end

# Format large numbers with suffixes like million, billion, etc.
def human_readable_number(number)
  units = [' ', 'thousand', 'million', 'billion', 'trillion', 'quadrillion', 'quintillion']
  unit = 0

  while number >= 1000 && unit < units.size - 1
    number /= 1000.0
    unit += 1
  end

  "#{number.round(2)} #{units[unit]}"
end


def count_solutions_in_directory(directory_path)
    total_solutions = 0
    Dir.glob("#{directory_path}/*.txt").each do |file|
      file_line_count = File.foreach(file).inject(0) { |count, _line| count + 1 }
      total_solutions += file_line_count
      puts "File #{file} contains #{file_line_count} solutions."
    end
    total_solutions
end
  
def count_solutions_in_directory(directory_path)
 total_solutions = 0
 Dir.glob("#{directory_path}/*.txt").each do |file|
   file_line_count = File.foreach(file).inject(0) { |count, _line| count + 1 }
   total_solutions += file_line_count
   #puts "File #{file} contains #{file_line_count} solutions."
 end
 total_solutions
end
