require 'parallel'
require 'etc'

# Get the number of queens from the command-line argument or default
def get_number_of_queens(max_queens)
  queens = $number_of_queens
  ARGV.each do |argv|
    queens = argv.delete('^0-9').to_i
    if queens.between?(1, max_queens)
      return queens
    else
      puts "Max Queens is set to #{max_queens} but you requested #{queens} queens!"
      exit
    end
  end
  queens
end

# Turn seconds into a human-readable format
def human_readable_time(secs)
  [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
    next unless secs > 0

    secs, number = secs.divmod(count)
    "#{number.to_i} #{number == 1 ? name.to_s.delete_suffix('s') : name}" unless number.to_i.zero?
  end.compact.reverse.join(', ')
end

# Format the time since start_time in a readable format
def format_time(start_time)
  time = Time.now - start_time
  if time > 100
    human_readable_time(time.round(6))
  else
    "#{time.round(6)} seconds"
  end
end
