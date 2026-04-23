# Codex Prompt: Convert n_queens to a Ruby Gem

## Purpose

Convert the existing `n_queens` repository into a properly structured, publishable
Ruby gem named `n_queens` with a clean public API. The existing solver logic must be
preserved exactly. No algorithmic changes are permitted.

## Constraints

- Do NOT modify any solver logic in the existing includes/ files
- Do NOT change algorithm behavior
- Do NOT remove any of the three solving methods
- Preserve the `parallel` gem dependency for parallel bitmasking
- All existing functionality must remain working after the conversion

## Target Gem Structure

```
n_queens/
  lib/
    n_queens.rb                    # main require and public API
    n_queens/
      version.rb                   # NQueens::VERSION constant
      result.rb                    # NQueens::Result value object
      solver.rb                    # NQueens::Solver - dispatches by n
      backtracking.rb              # NQueens::Backtracking - wraps existing logic
      bitmask.rb                   # NQueens::Bitmask - wraps existing logic
      parallel_bitmask.rb          # NQueens::ParallelBitmask - wraps existing logic
      known_counts.rb              # NQueens::KNOWN_COUNTS - OEIS A000170 ground truth
  includes/                        # existing files - DO NOT MODIFY
  spec/
    n_queens_spec.rb               # basic RSpec tests
  n_queens.gemspec
  Gemfile
  CHANGELOG.md
  README.md                        # update existing README
  LICENSE.md                       # keep existing
  .gitignore                       # update to add gem build artifacts
```


## Public API

### NQueens::Solver

```ruby
solver = NQueens::Solver.new(n)
result = solver.solve

result.n          # => Integer board size
result.count      # => Integer number of solutions
result.solutions  # => Array of placement arrays, or nil for large n (n >= 18)
result.method     # => Symbol :backtracking | :bitmask | :parallel_bitmask
result.duration   # => Float elapsed seconds
```

### Method dispatch (mirrors existing n_queens.rb logic)

- n <= 10   : use backtracking (returns full solutions array)
- 11..17    : use parallel bitmask (returns full solutions array)
- n >= 18   : use parallel bitmask to file (result.solutions returns nil, result.count reads from files)

### NQueens::KNOWN_COUNTS

Ground truth solution counts from OEIS A000170:

```ruby
NQueens::KNOWN_COUNTS[1]  # => 1
NQueens::KNOWN_COUNTS[4]  # => 2
NQueens::KNOWN_COUNTS[8]  # => 92
NQueens::KNOWN_COUNTS[12] # => 14200
NQueens::KNOWN_COUNTS[14] # => 365596
```

Include values for n = 1 through 15 at minimum.

### NQueens::VERSION

```ruby
NQueens::VERSION  # => "1.0.0"
```


## Implementation Notes

### NQueens::Backtracking

Wrap `solve_n_queens_fast` from `includes/n_queens_backtracking.rb`.
Require the includes file and delegate to the existing method.
Return solutions array directly.

```ruby
module NQueens
  class Backtracking
    def initialize(n)
      @n = n
    end

    def solve
      # delegate to existing solve_n_queens_fast(@n)
      # return solutions array
    end
  end
end
```

### NQueens::Bitmask

Wrap `solve_n_queens_bitmask` from `includes/n_queens_bitmasking.rb`.

### NQueens::ParallelBitmask

Wrap `solve_n_queens_bitmask_parallel` from `includes/n_queens_bitmasking.rb`.
Use `Etc.nprocessors` for processor count, same as existing logic.
For n >= 18, use `solve_n_queens_bitmask_parallel_to_file` from
`includes/n_queens_bitmasking_to_file.rb`.

### Global variable elimination

The existing code uses globals ($number_of_queens, $show_elapsed_time, etc.).
The wrapper classes must initialize these globals before delegating to the
existing methods, since the existing methods depend on them.

Do NOT refactor the existing include files to remove globals.
Instead, set the required globals in the wrapper class before calling
the existing methods.

Required globals to set before calling existing methods:
- $number_of_queens
- $show_elapsed_time = false  (suppress output in gem context)
- $enable_garbage_collection = false
- $start_time = Time.now
- $line_count = 0
- $total_processors = Etc.nprocessors
- $number_of_workers = Etc.nprocessors
- $collect_garbage = false

### NQueens::Result

```ruby
module NQueens
  Result = Struct.new(:n, :count, :solutions, :method, :duration)
end
```


## gemspec

```ruby
Gem::Specification.new do |spec|
  spec.name          = "n_queens"
  spec.version       = NQueens::VERSION
  spec.authors       = ["Tim Bass"]
  spec.email         = []
  spec.summary       = "N-Queens solver with backtracking, bitmasking, and parallel bitmasking"
  spec.description   = "Solves the N-Queens problem using dynamically selected algorithms. Returns solution count and solutions array for small n."
  spec.homepage      = "https://github.com/unixneo/n_queens"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files         = Dir["lib/**/*", "includes/**/*", "LICENSE.md", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "parallel"
end
```

## Gemfile

```ruby
source "https://rubygems.org"
gemspec
group :development, :test do
  gem "rspec"
end
```

## RSpec tests (spec/n_queens_spec.rb)

Write tests verifying:

1. `NQueens::Solver.new(1).solve.count == 1`
2. `NQueens::Solver.new(4).solve.count == 2`
3. `NQueens::Solver.new(8).solve.count == 92`
4. `NQueens::Solver.new(8).solve.solutions.size == 92`
5. Each solution in n=8 result is a valid placement:
   - Array of 8 integers
   - No two queens share a column
   - No two queens share a diagonal
6. `NQueens::KNOWN_COUNTS[8] == 92`
7. `NQueens::VERSION` is a non-empty string

## Verification

After implementation run:

```bash
bundle exec rspec
```

All specs must pass.

Also verify the gem builds cleanly:

```bash
gem build n_queens.gemspec
```

## CHANGELOG.md

Create with initial entry:

```
## [1.0.0] - 2026-04-22

### Added
- Initial gem release
- NQueens::Solver with automatic method dispatch
- NQueens::Result value object
- NQueens::KNOWN_COUNTS ground truth from OEIS A000170
- Backtracking solver for n <= 10
- Parallel bitmask solver for n 11-17
- Parallel bitmask to file solver for n >= 18
```

## Success Criteria

1. ✅ `bundle exec rspec` passes all specs
2. ✅ `gem build n_queens.gemspec` succeeds without warnings
3. ✅ Public API matches specification above
4. ✅ No modifications to any file in includes/
5. ✅ NQueens::KNOWN_COUNTS includes values for n=1 through n=15
6. ✅ Globals are set before delegating to existing methods
7. ✅ result.solutions returns nil for n >= 18 (not an error)

---

**Ready for Codex implementation.**
**PI approval:** 2026-04-22
