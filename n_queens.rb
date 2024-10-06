# Static variables for the number of queens and the board size
$number_of_queens = 8  # Default value, can be changed with command-line argument
$show_solutions = false  # Set this to true to print all solutions
$max_queens = 18  # Upper limit to avoid too long of a runtime for very large boards

start_time = Time.now

# Load helper methods from the includes file
require_relative "includes/n_queens_includes"

# Get the number of queens via command line argument or default
$number_of_queens = get_number_of_queens($max_queens)

# Choose which method to solve the n-queens problem
# Uncomment one of the following lines to choose the solving method:

# Standard backtracking with pruning (fast for moderate board sizes)
# solutions = solve_n_queens_fast($number_of_queens)

# Optimized bitmask solution (faster for larger board sizes)
# solutions = solve_n_queens_bitmask($number_of_queens)

# Parallel execution (useful for larger board sizes, e.g., 12x12 or greater)
solutions = solve_n_queens_parallel($number_of_queens)

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

# Display the number of solutions and execution time
str_time = format_time(start_time)
puts "Number of solutions: #{solutions.size.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}\n"