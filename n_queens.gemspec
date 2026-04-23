require_relative "lib/n_queens/version"

Gem::Specification.new do |spec|
  spec.name = "n_queens"
  spec.version = NQueens::VERSION
  spec.authors = ["Tim Bass"]
  spec.email = []
  spec.summary = "N-Queens solver with backtracking, bitmasking, and parallel bitmasking"
  spec.description = "Solves the N-Queens problem using dynamically selected algorithms. Returns solution count and solutions array for small n."
  spec.homepage = "https://github.com/unixneo/n_queens"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir["lib/**/*", "includes/**/*", "LICENSE.md", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "parallel", "~> 1.26"
end
