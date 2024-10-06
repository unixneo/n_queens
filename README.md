
## n_queens

This project provides a flexible and efficient solution to the N-Queens problem, allowing you to solve the problem for any board size using various algorithms, including backtracking, bitmasking, and parallel execution for larger boards.

Features

	•	Backtracking with Pruning: An efficient backtracking algorithm that prunes invalid solutions early.
	•	Bitmasking Optimization: Uses bitwise operations for faster performance on larger board sizes.
	•	Parallel Execution: Leverages parallel processing to solve the problem faster on multi-core machines.
	•	Configurable Board Size: Solve the N-Queens problem for any board size by passing a command-line argument.
	•	Execution Time: Displays the number of solutions found and the time it took to compute them.

Table of Contents

	1.	Installation
	2.	Usage
	3.	Solving Methods
	•	Backtracking
	•	Bitmasking
	•	Parallel Execution
	4.	Example Outputs
	5.	License

### Installation

Clone this repository to your local machine:

git clone https://github.com/your-username/n-queens-solver.git
cd n_queens

Ensure you have Ruby installed on your machine (Ruby version 2.7 or higher recommended).

To use parallel execution, you’ll need the parallel gem:

gem install parallel

### Usage

You can run the N-Queens solver by executing the n_queens.rb script:

#### Default (8-Queens Problem):

ruby n_queens.rb

#### Custom Board Size (e.g., 12-Queens Problem):

ruby n_queens.rb 12

### Show Solutions:

To display all solutions found, edit the main file and set the $show_solutions flag to true:

$show_solutions = true

### Solving Methods

There are three different algorithms implemented to solve the N-Queens problem. You can select which algorithm to use by uncommenting the respective line in the main file.

#### 1. Backtracking with Pruning

This method uses backtracking and prunes the search space by skipping invalid positions early in the recursion.

To use this method, uncomment the following line in the main file:

solutions = solve_n_queens_fast($number_of_queens)

#### 2. Bitmasking Optimization

This method uses bitwise operations for faster performance and reduced memory usage, especially useful for larger boards.

To use this method, uncomment the following line in the main file:

solutions = solve_n_queens_bitmask($number_of_queens)

#### 3. Parallel Execution

For large boards (e.g., n = 12 or higher), you can enable parallel execution to speed up the computation using multiple CPU cores.

To use this method, uncomment the following line in the main file:

solutions = solve_n_queens_parallel($number_of_queens)

Ensure the parallel gem is installed to support multi-core processing.

### Example Outputs

When $show_solutions = true, the program will output each solution found. Below is an example of a solution for the 4-Queens problem:

Solution 1:
Queen placed at: Row 0, Column 1
Queen placed at: Row 1, Column 3
Queen placed at: Row 2, Column 0
Queen placed at: Row 3, Column 2

At the end of the program, it will display the total number of solutions found and the time it took to compute them:

Number of solutions: 92 for 8 Queens in 0.123456s

### License

This project is licensed under the MIT License. See the LICENSE file for details.



### See Also:

- [Wikipedia: 8 Queens Problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle)
- [Solving 4-queen problem: Translate my logic to code? Unable to do so](https://community.unix.com/t/solving-4-queen-problem-translate-my-logic-to-code-unable-to-do-so/395405)
