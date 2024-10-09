require 'etc'

# Static variables for the number of queens and the board size
$number_of_queens = 8  # Default value, can be changed with command-line argument
$show_solutions = false # Set this to true to print all solutions
$show_elasped_time = true # Set this to see some output on long processing times
$max_queens = 18  # Upper limit to avoid too long of a runtime for very large boards
$modulo_time = 0
number_of_processors = Etc.respond_to?(:nprocessors) ? Etc.nprocessors : 4
start_time = Time.now
$start_time = Time.now #Process.clock_gettime(Process::CLOCK_MONOTONIC)
method_name = ""  # Variable to store the method used

# Load helper methods from the include filew
require_relative "includes/n_queens_core"
require_relative "includes/n_queens_backtracking"
require_relative "includes/n_queens_bitmasking"

# Get the number of queens via command line argument or default
$number_of_queens = get_number_of_queens($max_queens)

# Automatically select the best method based on the size of `n`
if $number_of_queens <= 10
  method_name = "Backtracking with Pruning"
  puts "#{Time.now} >>> Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
  solutions = solve_n_queens_fast($number_of_queens)
elsif $number_of_queens <= 12
  method_name = "Optimized Bitmasking"
  puts "#{Time.now} >>> Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
  solutions = solve_n_queens_bitmask($number_of_queens)
elsif  $number_of_queens <= 17
  $modulo_time = 60
  puts "#{Time.now} >>> Number of Working Processor for Tasks is #{number_of_processors}"
  method_name = "Parallel Processing Bitmasking N < 18"
  puts "#{Time.now} >>> Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
  solutions = solve_n_queens_bitmask_parallel($number_of_queens, number_of_processors)
else
  $modulo_time = 600
  puts "#{Time.now} >>> Number of Working Processor for Tasks is #{number_of_processors - 2}"
  method_name = "Parallel Processing Bitmasking N >= 18"
  puts "#{Time.now} >>> Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
  solutions = solve_n_queens_bitmask_parallel($number_of_queens, number_of_processors - 2 )
end


# Print solutions if the flag $show_solutions is true
show_solutions(solutions) if $show_solutions


# Display the method name, number of solutions, and execution time
str_time = format_time(start_time)
puts "#{Time.now} >>> Number of solutions: #{solutions.size.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}\n"