# Static variable for the number of queens and the board size
$number_of_queens = 8 # Change this value to solve for different sizes of queens and board (e.g., 8 for 8x8)
$show_solutions = true # Change this falue to print of the solutions
start_time = Time.now

require_relative "includes/n_queens_includes"

# Generate the hash for the NxN board
queen_moves_n_queens = generate_queen_moves_for_n_queens

# Solve the n-queens problem
solutions ||= solve_n_queens(queen_moves_n_queens)

# Print all the solutions
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
  
str_time = format_time(start_time)
puts "Number of solutions: #{solutions.size.to_s.gsub(/\B(?=(...)*\b)/, ',')} for #{$number_of_queens} Queens in #{str_time} \n"
