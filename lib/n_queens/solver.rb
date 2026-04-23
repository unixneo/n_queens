module NQueens
  class Solver
    def initialize(n)
      @n = Integer(n)
      raise ArgumentError, "n must be >= 1" if @n < 1
    end

    def solve
      started_at = Time.now

      method, raw_solutions, count =
        if @n <= 10
          solutions = NQueens::Backtracking.new(@n).solve
          [ :backtracking, solutions, solutions.size ]
        elsif @n <= 17
          solutions = NQueens::ParallelBitmask.new(@n).solve
          [ :parallel_bitmask, solutions, solutions.size ]
        else
          parallel = NQueens::ParallelBitmask.new(@n)
          parallel.solve
          [ :parallel_bitmask, nil, parallel.count_from_files ]
        end

      NQueens::Result.new(
        @n,
        count,
        raw_solutions,
        method,
        Time.now - started_at
      )
    end
  end
end
