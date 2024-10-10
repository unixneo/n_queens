require 'etc'

# Static variables for the number of queens and the board size
$number_of_queens = 8  # Default value, can be changed with command-line argument
$show_solutions = false # Set this to true to print all solutions
$show_elasped_time = true # Set this to see some output on long processing times
$max_queens = 18  # Upper limit to avoid too long of a runtime for very large boards
$modulo_time = 0  # Initialize global variable used for heartbeat output
$start_time = Time.now #Process.clock_gettime(Process::CLOCK_MONOTONIC)
$line_count = 0 # Counter used to print out stuff
$collect_garbage = true   # Enable GC.start in parellel processing
# Load helper methods from the include file
require_relative "n_queens_core"
require_relative "n_queens_backtracking"
require_relative "n_queens_bitmasking"
