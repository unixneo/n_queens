#############################################
# Main N Queens File
# https://www.github.com/unixneo/n_queens.git
# Betelgeuse Version
##############################################

require_relative "includes/n_queens_config"
require_relative "includes/n_queens_common"

# Get total number of CPU processors for parallel processing
$total_processors = Etc.respond_to?(:nprocessors) ? Etc.nprocessors : 4
$start_time = Time.now
$enable_garbage_collection = false
$write_to_file_cutoff = 12

def log_message(message)
  puts "#{Time.now} >>> #{message}"
end

def select_n_queens_method
  if $number_of_queens <= 10
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Backtracking with Pruning Method")
    solve_n_queens_fast($number_of_queens)
  elsif false && $number_of_queens <= 12
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Optimized Bitmasking Method")
    solve_n_queens_bitmask($number_of_queens)
  elsif $number_of_queens < $write_to_file_cutoff
    $enable_garbage_collection = false
    $number_of_workers = $total_processors
    log_message("Number of Working Processors: #{$number_of_workers} - Garbage Collection: #{$enable_garbage_collection}")
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Parallel Processing Bitmasking N < 18 Method")
    solve_n_queens_bitmask_parallel($number_of_queens,$number_of_workers)
  else
    $enable_garbage_collection = true
    $number_of_workers = $total_processors > 3 ? $total_processors - 2 : $total_processors
    log_message("Number of Working Processors: #{$number_of_workers} - Garbage Collection: #{$enable_garbage_collection} with Write to File")
    log_message("Started Solving N-Queens with #{$number_of_queens} Queens using Parallel Processing Bitmasking to File N >= 18 Method")
    #solve_n_queens_bitmask_parallel($number_of_queens, $number_of_workers)
    solve_n_queens_bitmask_parallel_to_file($number_of_queens, $number_of_workers)
  end
end

# Get the number of queens via command line argument or default
$number_of_queens = get_number_of_queens($max_queens)

# Automatically select the best method based on the size of `n`
solutions = select_n_queens_method

if $number_of_queens < $write_to_file_cutoff
  show_solutions(solutions) if $show_solutions
  total_solutions = solutions.size
else
  total_solutions = get_total_count($dir_name)
end

# Display the method name, number of solutions, and execution time
str_time = format_time($start_time)
log_message("Number of solutions: #{total_solutions.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}")

