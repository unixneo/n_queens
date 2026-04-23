module NQueens
  class Bitmask
    def initialize(n)
      @n = n
    end

    def solve
      prepare_globals
      solve_n_queens_bitmask(@n)
    end

    private

    def prepare_globals
      processors = Etc.respond_to?(:nprocessors) ? Etc.nprocessors : 4

      $number_of_queens = @n
      $show_elapsed_time = false
      $show_solutions = false
      $enable_garbage_collection = false
      $start_time = Time.now
      $line_count = 0
      $total_processors = processors
      $number_of_workers = processors
      $collect_garbage = false
    end
  end
end
