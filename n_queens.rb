# Static variable for the number of queens and the board size
$number_of_queens = 8 # Change this value to solve for different sizes of queens and board (e.g., 8 for 8x8)
$show_solutions = false # Change this falue to print of the solutions
$max_queens = 18 # Change this value to make this run too long :)

start_time = Time.now

require_relative "includes/n_queens_includes"

ARGV.each do |argv|
  # Usage:   ruby n_queens.rb 10
  queens = argv.to_i
  if queens.between?(1,$max_queens)
    $number_of_queens = queens
    break
  else
    puts "Max Queens is set to #{$max_queens} but you requested #{queens} Queens!\n" 
    exit
  end
end


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
