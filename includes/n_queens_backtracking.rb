# ================================
# Standard Backtracking with Pruning
# ================================
def solve_n_queens_fast(board_size)
    solutions = []
    columns = Array.new(board_size, false)
    main_diag = Array.new(2 * board_size - 1, false)  # Main diagonals (row - col)
    anti_diag = Array.new(2 * board_size - 1, false)  # Anti-diagonals (row + col)
  
    place_queen(0, [], board_size, columns, main_diag, anti_diag, solutions)
    solutions
  end
  
  # Helper function for standard backtracking to place queens
  def place_queen(row, queens, board_size, columns, main_diag, anti_diag, solutions)
    if row == board_size
      solutions << queens.dup
      return
    end
  
    board_size.times do |col|
      if !columns[col] && !main_diag[row - col + board_size - 1] && !anti_diag[row + col]
        # Mark this column and diagonals as occupied
        columns[col] = main_diag[row - col + board_size - 1] = anti_diag[row + col] = true
        queens.push(col)
  
        place_queen(row + 1, queens, board_size, columns, main_diag, anti_diag, solutions)
  
        # Backtrack and unmark the column and diagonals
        columns[col] = main_diag[row - col + board_size - 1] = anti_diag[row + col] = false
        queens.pop
      end
    end
 end