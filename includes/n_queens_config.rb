require 'etc'
require 'pathname'

# Configuration variables
$number_of_queens = 8  # Default number of queens, can be changed via command-line argument
$show_solutions = false  # Toggle to true to display all solutions
$show_elapsed_time = true  # Toggle to true to show output for long-running tasks
$max_queens = 18  # Upper limit to avoid excessive runtime for large board sizes
$modulo_time = 0  # Global variable used for heartbeat output
$start_time = Time.now  # Start time for tracking elapsed time
$line_count = 0  # Counter for logging and garbage collection

# Load helper methods from external include files
require_relative "n_queens_common"
require_relative "n_queens_backtracking"
require_relative "n_queens_bitmasking"
require_relative "n_queens_bitmasking_to_file"
require_relative "n_queens_count_solutions_in_files"