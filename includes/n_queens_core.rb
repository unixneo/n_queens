# Logs the message with a timestamp
def log_message(message)
  puts "#{Time.now} >>> #{message}"
end

# Get the number of queens from the command-line argument or default
def get_number_of_queens(max_queens)
  ARGV.each do |argv|
    queens = argv.delete('^0-9').to_i
    if queens.between?(1, max_queens)
      return queens
    else
      log_message("Max Queens is set to #{max_queens} but you requested #{queens} queens!")
      exit
    end
  end
  $number_of_queens
end

# Convert seconds into a human-readable format
def human_readable_time(secs)
  [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
    next unless secs > 0

    secs, number = secs.divmod(count)
    "#{number.to_i} #{name.to_s.delete_suffix('s') if number == 1}" unless number.to_i.zero?
  end.compact.reverse.join(', ')
end

# Format the time since start_time in a readable format
def format_time(start_time)
  elapsed_time = Time.now - start_time
  elapsed_time > 100 ? human_readable_time(elapsed_time.round(6)) : "#{elapsed_time.round(6)} seconds"
end

# Display solutions if available
def show_solutions(solutions)
  if solutions.empty?
    log_message("No solutions found")
  else
    solutions.each_with_index do |solution, index|
      log_message("Solution #{index + 1}:")
      solution.each_with_index do |col, row|
        puts "Queen placed at: Row #{row}, Column #{col}"
      end
      puts "\n"
    end
  end
end