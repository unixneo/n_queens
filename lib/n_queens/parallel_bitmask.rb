module NQueens
  class ParallelBitmask
    def initialize(n)
      @n = n
    end

    def solve
      prepare_globals
      workers = Etc.respond_to?(:nprocessors) ? Etc.nprocessors : 4

      if @n >= 18
        solve_n_queens_bitmask_parallel_to_file(@n, workers)
        nil
      else
        solve_n_queens_bitmask_parallel(@n, workers)
      end
    end

    def count_from_files
      get_total_count($dir_name)
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
