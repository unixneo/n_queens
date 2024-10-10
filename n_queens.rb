#############################################
# Main N Queens File
# https://www.github.com/unixneo/n_queens.git
# Andromeda Version 0.2
##############################################

require_relative "includes/n_queens_config"

# Get total number of CPU processors for parallel processing
total_number_of_processors = Etc.respond_to?(:nprocessors) ? Etc.nprocessors : 4
start_time = Time.now

method_name = ""  # Variable to store the method used

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
  $collect_garbage = true 
  puts "#{Time.now} >>> Number of Working Processor for Tasks is #{total_number_of_processors}"
  method_name = "Parallel Processing Bitmasking N < 18"
  puts "#{Time.now} >>> Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
  solutions = solve_n_queens_bitmask_parallel($number_of_queens, total_number_of_processors)
else
  $collect_garbage = true   # Enable GC.start in parellel processing
  $working_processors = total_number_of_processors - 2
  puts "#{Time.now} >>> Number of Working Processor for Tasks is #{$working_processors} - Garbage Collection is #{$collect_garbage}\n"
  method_name = "Parallel Processing Bitmasking N >= 18"
  puts "#{Time.now} >>> Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
  solutions = solve_n_queens_bitmask_parallel($number_of_queens, $working_processors )
end


# Print solutions if the flag $show_solutions is true
show_solutions(solutions) if $show_solutions

# Display the method name, number of solutions, and execution time
str_time = format_time(start_time)
puts "#{Time.now} >>> Number of solutions: #{solutions.size.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}\n"