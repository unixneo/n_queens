# n_queens

Solving the Classic NxN Queens Puzzle Using Positional Arrays in Ruby

# How It Works:

	1.	Static Variable $number_of_queens: This variable defines both the number of queens and the size of the board. You can change it to solve for any board size (e.g., 8 for an 8x8 board).
	2.	Generic Queen Moves Generation: The generate_queen_moves_for_n_queens function generates the queen’s movement arrays for any board size by using $number_of_queens as the dynamic board size.
	3.	Recursive Solution: The solve_n_queens function recursively tries to place queens on the board, checks for conflicts using the is_safe function, and stores all valid solutions.
	4.	Print Solutions: The code prints each solution, showing where the queens are placed (with their row and column positions).

# To Use for Any n-Queens Problem:

	•	Simply change the value of $number_of_queens at the top of the script to your desired number (e.g., 4 for a 4x4 board, 8 for an 8x8 board, etc.).

Example:

If you set $number_of_queens = 9, the code will find and print all solutions for the 9-queens problem.
