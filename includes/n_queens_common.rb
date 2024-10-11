# Logs the message with a timestamp
def log_message(message)
  puts "#{Time.now} >>> #{message}"
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

def get_total_count(directory_path) 
  total_solutions = count_solutions_in_directory(directory_path)
  total_solutions
end

def count_solutions_in_directory(directory_path)
 total_solutions = 0
 Dir.glob("#{directory_path}/*.txt").each do |file|
   file_line_count = File.foreach(file).inject(0) { |count, _line| count + 1 }
   total_solutions += file_line_count
   #puts "File #{file} contains #{file_line_count} solutions."
 end
 total_solutions
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