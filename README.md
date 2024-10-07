# N-Queens Solver

This project provides a flexible, efficient, and dynamically optimized solution to the **N-Queens problem**. It includes multiple solving methods, each tailored for different board sizes, ensuring the best performance for any `n`.

## Features

- **Dynamic Method Selection**: Automatically selects the most efficient algorithm based on the board size (`n`).
- **Backtracking with Pruning**: Optimized backtracking algorithm for small board sizes.
- **Bitmasking**: A memory-efficient solution using bitwise operations, best for medium board sizes.
- **Parallel Bitmasking**: Utilizes multi-core CPUs to solve large board sizes efficiently.
- **Execution Time Reporting**: Displays the method used, the number of solutions, and the total execution time.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Solving Methods](#solving-methods)
  - [Backtracking with Pruning](#backtracking-with-pruning)
  - [Optimized Bitmasking](#optimized-bitmasking)
  - [Parallel Bitmasking](#parallel-bitmasking)
  - [Dynamic Method Selection](#dynamic-method-selection)
- [Example Output](#example-output)
- [License](#license)

## Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/unixneo/n_queens.git
   cd n_queens
   ```

2. Ensure you have Ruby installed (version 2.7 or higher recommended).

3. Install the `parallel` gem for parallel execution:

   ```bash
   gem install parallel
   ```

## Usage

You can run the solver by executing the `n_queens.rb` script:

### Default (8 Queens)

```bash
ruby n_queens.rb
```

### Custom Board Size

```bash
ruby n_queens.rb <board_size>
```

For example, to solve the 12-Queens problem:

```bash
ruby n_queens.rb 12
```

### Show Solutions

If you want to print all the solutions found, set `$show_solutions` to `true` in the **main file**:

```ruby
$show_solutions = true
```

## Solving Methods

This project supports three solving methods, automatically choosing the best one based on the size of the board (`n`).

### 1. Backtracking with Pruning

Used for small board sizes (`n <= 10`), this method efficiently prunes invalid queen placements early in the recursion.

### 2. Optimized Bitmasking

For medium board sizes (`n <= 12`), the bitmasking approach leverages bitwise operations to track column and diagonal conflicts, reducing memory and computation overhead.

### 3. Parallel Bitmasking

For large board sizes (`n > 12`), this method combines bitmasking with parallel execution. It distributes the workload across multiple CPU cores, solving each possible queen placement in parallel for maximum performance.

## Dynamic Method Selection

The main file automatically selects the most appropriate method based on the size of `n`:

- **Backtracking with Pruning** for `n <= 10`
- **Optimized Bitmasking** for `n <= 12`
- **Parallel Bitmasking** for `n > 12`

This ensures the solver runs as efficiently as possible without needing manual method selection.

## Example Output

Here's an example output for the 8-Queens problem with **Parallel Bitmasking**:

```
Method used: Parallel Bitmasking
Number of solutions: 92 for 8 Queens in 0.123456s
```

When `$show_solutions` is enabled, you'll also see the exact queen placements for each solution:

```
Solution 1:
Queen placed at: Row 0, Column 0
Queen placed at: Row 1, Column 4
Queen placed at: Row 2, Column 7
Queen placed at: Row 3, Column 5
Queen placed at: Row 4, Column 2
Queen placed at: Row 5, Column 6
Queen placed at: Row 6, Column 1
Queen placed at: Row 7, Column 3
```

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/unixneo/n_queens/blob/main/LICENSE.md) file for details.


## See Also:

- [Wikipedia: 8 Queens Problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle)
- [Solving 4-queen problem: Translate my logic to code? Unable to do so](https://community.unix.com/t/solving-4-queen-problem-translate-my-logic-to-code-unable-to-do-so/395405)


## Authors

- [unixneo](https://github.com/unixneo)
- [ChatGPT 4o](https://chatgpt.com/?model=gpt-4o)
