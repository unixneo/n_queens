require 'etc'
require 'pathname'

# Static Constants
MAX_QUEENS = 20  # Upper limit to avoid excessive runtime for large board sizes
COUNT_SOLUTIONS_ONLY = true
DO_NOT_COUNT_SOLUTIONS_ONLY = false
SHOW_SOLUTIONS = false  # Toggle to true to display all solutions
SHOW_ELASPED_TIME = true  # Toggle to true to show output for long-running tasks
WRITE_TO_FILE_CUTOFF = 12 # number of queens where we write to file instead of process in memory

# Configuration variables
$number_of_queens = 8  # Default number of queens, can be changed via command-line argument
$modulo_time = 0  # Global variable used for heartbeat output
$start_time = Time.now  # Start time for tracking elapsed time
$line_count = 0  # Counter for logging and garbage collection

# Load helper methods from external include files
require_relative "n_queens_common"
require_relative "n_queens_backtracking"
require_relative "n_queens_bitmasking"
require_relative "n_queens_bitmasking_to_file"
require_relative "n_queens_count_solutions_in_files"