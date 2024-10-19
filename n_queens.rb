#############################################
# Main N Queens File
# https://www.github.com/unixneo/n_queens.git
# Count Solutions Only Version
##############################################

#require 'memory_profiler'

require_relative "includes/n_queens_config"
require_relative "includes/n_queens_common"

# Get total number of CPU processors for parallel processing
$total_processors = Etc.respond_to?(:nprocessors) ? Etc.nprocessors : 4
$start_time = Time.now
$enable_garbage_collection = false


def log_message(message)
  puts "#{Time.now} >>> #{message}"
end

def select_n_queens_method
  if DO_NOT_COUNT_SOLUTIONS_ONLY  && $number_of_queens <= 10
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Backtracking with Pruning Method")
    solve_n_queens_fast($number_of_queens)
  elsif DO_NOT_COUNT_SOLUTIONS_ONLY  && $number_of_queens <= 12
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Optimized Bitmasking Method")
    solve_n_queens_bitmask($number_of_queens)
  elsif DO_NOT_COUNT_SOLUTIONS_ONLY  && $number_of_queens < WRITE_TO_FILE_CUTOFF
    $enable_garbage_collection = false
    $number_of_workers = $total_processors
    log_message("Number of Working Processors: #{$number_of_workers} - Garbage Collection: #{$enable_garbage_collection}")
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Parallel Processing Bitmasking N < 18 Method")
    solve_n_queens_bitmask_parallel($number_of_queens,$number_of_workers)
  else
    $enable_garbage_collection = true
    $number_of_workers = $total_processors > 3 ? $total_processors - 2 : $total_processors
    #$number_of_workers = 2
    log_message("Number of Working Processors: #{$number_of_workers} - Garbage Collection: #{$enable_garbage_collection} Count Solutions Only")
    log_message("Started Counting N-Queens with #{$number_of_queens} Queens using Parallel Processing Bitmasking to File N >= 18 Method")
    #solve_n_queens_bitmask_parallel($number_of_queens, $number_of_workers)
    solve_n_queens_bitmask_parallel_to_file($number_of_queens, $number_of_workers)
  end
end

# Get the number of queens via command line argument or default
$number_of_queens = get_number_of_queens(MAX_QUEENS)

# Automatically select the best method based on the size of `n`
solutions = select_n_queens_method

if DO_NOT_COUNT_SOLUTIONS_ONLY  && $number_of_queens < WRITE_TO_FILE_CUTOFF
  show_solutions(solutions) if SHOW_SOLUTIONS
  total_solutions = solutions.size
else
  if DO_NOT_COUNT_SOLUTIONS_ONLY  && $number_of_queens < 20
    total_solutions = get_total_count($dir_name)
  else
    total_solutions = get_total_counts_from_files($dir_name)
  end
end

# Display the method name, number of solutions, and execution time
str_time = format_time($start_time)
log_message("Number of solutions: #{total_solutions.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}")

