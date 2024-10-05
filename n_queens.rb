# Static variable for the number of queens and the board size
$number_of_queens = 9  # Change this value to solve for different sizes of queens and board (e.g., 8 for 8x8)

# Function to generate queen's movement array for each position on an NxN board
def generate_queen_moves(row, col)
  board_size = $number_of_queens
  moves = Array.new(board_size * board_size, 0)

  # Mark all positions in the same row
  (0...board_size).each { |c| moves[row * board_size + c] = 1 }

  # Mark all positions in the same column
  (0...board_size).each { |r| moves[r * board_size + col] = 1 }

  # Mark top-left to bottom-right diagonal
  (-[row, col].min..[board_size - 1 - row, board_size - 1 - col].min).each do |i|
    moves[(row + i) * board_size + (col + i)] = 1
  end

  # Mark top-right to bottom-left diagonal
  (-[row, board_size - 1 - col].min..[board_size - 1 - row, col].min).each do |i|
    moves[(row + i) * board_size + (col - i)] = 1
  end

  moves
end

# Function to generate the entire hash of queen moves for all positions on an NxN board
def generate_queen_moves_for_n_queens
  queen_moves = {}
  board_size = $number_of_queens
  (0...board_size).each do |row|
    (0...board_size).each do |col|
      pos = row * board_size + col
      queen_moves["Position #{pos}"] = generate_queen_moves(row, col)
    end
  end
  queen_moves
end

# Function to check if placing a queen at the current position is safe
def is_safe(position, queens, queen_moves)
  queens.each do |q|
    # Check for conflicts in movement based on queen's attackable positions
    return false if queen_moves["Position #{q}"][position] == 1
  end
  true
end

# Recursive function to solve the n-queens problem
def solve_n_queens(queen_moves, queens = [], row = 0, solutions = [])
  board_size = $number_of_queens
  if queens.size == board_size  # All queens placed
    solutions << queens.dup  # Store the solution
    return
  end

  (0...board_size).each do |col|  # Loop through all columns
    position = row * board_size + col  # Calculate position based on row and column
    if is_safe(position, queens, queen_moves)
      queens.push(position)  # Place the queen
      solve_n_queens(queen_moves, queens, row + 1, solutions)
      queens.pop  # Backtrack
    end
  end

  solutions
end

# Generate the hash for the NxN board
queen_moves_n_queens = generate_queen_moves_for_n_queens

# Solve the n-queens problem
solutions = solve_n_queens(queen_moves_n_queens)

# Print all the solutions
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
