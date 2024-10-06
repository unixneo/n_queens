# Static variables for the number of queens and the board size
$number_of_queens = 8  # Default value, can be changed with command-line argument
$show_solutions = false  # Set this to true to print all solutions
$max_queens = 18  # Upper limit to avoid too long of a runtime for very large boards

start_time = Time.now

# Load helper methods from the includes file
require_relative "includes/n_queens_includes"

# Get the number of queens via command line argument or default
$number_of_queens = get_number_of_queens

# Generate the hash for the NxN board
queen_moves_n_queens = generate_queen_moves_for_n_queens

# Solve the n-queens problem
solutions = solve_n_queens(queen_moves_n_queens)

# Print all solutions if the flag $show_solutions is true
if $show_solutions
  if solutions.empty?
    puts "No solutions found"
  else
    solutions.each_with_index do |solution, index|
      puts "Solution #{index + 1}:"
      solution.each do |pos|
        board_size = $number_of_queens
        puts "Queen placed at: Position #{pos} (Row #{pos / board_size}, Column #{pos % board_size})"
      end
      puts "\n"
    end
  end
end

# Display the number of solutions and execution time
str_time = format_time(start_time)
puts "Number of solutions: #{solutions.size.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time}\n"