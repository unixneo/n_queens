# Static variables for the number of queens and the board size
$number_of_queens = 8  # Default value, can be changed with command-line argument
$show_solutions = false  # Set this to true to print all solutions
$max_queens = 18  # Upper limit to avoid too long of a runtime for very large boards

start_time = Time.now
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
  solutions = solve_n_queens_fast($number_of_queens)
elsif $number_of_queens <= 12
  method_name = "Optimized Bitmasking"
  solutions = solve_n_queens_bitmask($number_of_queens)
else
  method_name = "Parallel Processing Bitmasking"
  solutions = solve_n_queens_bitmask_parallel($number_of_queens)
end

puts "Started Solving N-Queens with #{$number_of_queens} Queens using the #{method_name} Method\n"
# Print solutions if the flag $show_solutions is true
if $show_solutions
  if solutions.empty?
    puts "No solutions found"
  else
    solutions.each_with_index do |solution, index|
      puts "Solution #{index + 1}:"
      solution.each_with_index do |col, row|
        puts "Queen placed at: Row #{row}, Column #{col}"
      end
      puts "\n"
    end
  end
end

# Display the method name, number of solutions, and execution time
str_time = format_time(start_time)
puts "Number of solutions: #{solutions.size.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}\n"