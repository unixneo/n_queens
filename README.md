# N-Queens Solver

## Betelgeuse Version

[![Gem Version](https://badge.fury.io/rb/n_queens.svg)](https://rubygems.org/gems/n_queens)

This project provides a flexible, efficient, and dynamically optimized solution to the **N-Queens problem**. It includes multiple solving methods, each tailored for different board sizes, ensuring the best performance for any `n`.

Available as a Ruby gem at https://rubygems.org/gems/n_queens

## Features

* **Ruby Gem API:** Clean public API via `NQueens::Solver`
* **Dynamic Method Selection**: Automatically selects the most efficient algorithm based on the board size (`n`)
* **Backtracking with Pruning**: Optimized backtracking algorithm for small board sizes (n <= 10)
* **Parallel Bitmasking**: Utilizes multi-core CPUs to solve large board sizes efficiently (n 11-17)
* **Parallel Bitmasking to File**: Writes solutions to disk for very large board sizes (n >= 18)
* **OEIS A000170 Ground Truth**: `NQueens::KNOWN_COUNTS` provides peer-reviewed solution counts for n=1..15
* **Execution Time Reporting**: Displays the method used, the number of solutions, and the total execution time

## Installation

### As a gem

```bash
gem install n_queens
```

Or add to your Gemfile:

```ruby
gem "n_queens", "~> 1.0"
```

### From source

```bash
git clone https://github.com/unixneo/n_queens.git
cd n_queens
bundle install
```


## Gem API

```ruby
require "n_queens"

# Solve for a given board size
result = NQueens::Solver.new(8).solve

result.count      # => 92
result.solutions  # => Array of 92 placement arrays (nil for n >= 18)
result.method     # => :backtracking or :parallel_bitmask
result.duration   # => Float elapsed seconds

# Each solution is an array of column positions indexed by row
# result.solutions[0] => [0, 4, 7, 5, 2, 6, 1, 3]
# meaning: queen in row 0 is at column 0, row 1 at column 4, etc.

# OEIS A000170 ground truth solution counts
NQueens::KNOWN_COUNTS[1]  # => 1
NQueens::KNOWN_COUNTS[4]  # => 2
NQueens::KNOWN_COUNTS[8]  # => 92
NQueens::KNOWN_COUNTS[12] # => 14200
NQueens::KNOWN_COUNTS[14] # => 365596

# Version
NQueens::VERSION  # => "1.0.0"
```

## Command Line Usage

```bash
# Default (8 Queens)
ruby n_queens.rb

# Custom board size
ruby n_queens.rb 12
```

## Solving Methods

| Board size | Method |
|---|---|
| n <= 10 | Backtracking with pruning |
| n 11-17 | Parallel bitmasking |
| n >= 18 | Parallel bitmasking to file |


## Testing

```bash
bundle exec rspec
```

Expected output:
```
7 examples, 0 failures
```

## Building the Gem

```bash
gem build n_queens.gemspec
gem push n_queens-1.0.0.gem
```

## Example Output

```
2026-04-23 >>> Started Solving N-Queens with 8 Queens using Backtracking with Pruning Method
2026-04-23 >>> Number of solutions: 92 for 8 Queens in 0.012345 seconds
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## See Also

- [Wikipedia: 8 Queens Problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle)
- [OEIS A000170](https://oeis.org/A000170)
- [RubyGems: n_queens](https://rubygems.org/gems/n_queens)

## Authors

- unixneo
- Claude (Anthropic) - Architect
- Codex (OpenAI) - Coder
