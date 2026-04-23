require "n_queens"

RSpec.describe NQueens do
  def valid_solution?(placement)
    size = placement.length

    return false unless placement.all? { |column| column.is_a?(Integer) && column.between?(0, size - 1) }
    return false unless placement.uniq.length == size

    placement.each_with_index do |column, row|
      ((row + 1)...size).each do |next_row|
        next_column = placement[next_row]
        return false if (row - next_row).abs == (column - next_column).abs
      end
    end

    true
  end

  it "solves n=1 with count 1" do
    result = NQueens::Solver.new(1).solve

    expect(result.count).to eq(1)
  end

  it "solves n=4 with count 2" do
    result = NQueens::Solver.new(4).solve

    expect(result.count).to eq(2)
  end

  it "solves n=8 with count 92" do
    result = NQueens::Solver.new(8).solve

    expect(result.count).to eq(92)
  end

  it "returns all n=8 solutions" do
    result = NQueens::Solver.new(8).solve

    expect(result.solutions.size).to eq(92)
  end

  it "returns valid n=8 placements" do
    result = NQueens::Solver.new(8).solve

    expect(result.solutions).to all(satisfy { |placement| valid_solution?(placement) })
  end

  it "provides known counts" do
    expect(NQueens::KNOWN_COUNTS[8]).to eq(92)
  end

  it "provides a version string" do
    expect(NQueens::VERSION).to be_a(String)
    expect(NQueens::VERSION).not_to be_empty
  end
end
