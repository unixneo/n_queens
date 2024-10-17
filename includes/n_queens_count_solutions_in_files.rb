require 'pathname'


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

def get_total_counts_from_files(directory_path)
  total_sum = 0
  Dir.foreach(directory_path) do |filename|
    
    # Skip '.' and '..' which represent current and parent directories
    next if filename == '.' || filename == '..'

    file_path = File.join(directory_path, filename)

    # Only process regular files (not directories)
    next unless File.file?(file_path)

    
    # Read each line of the file and sum the integers
    File.foreach(file_path) do |line|
      puts "FILE PATH #{file_path} Count: #{line.to_i}"
      total_sum += line.to_i
      puts "FILE PATH #{file_path} Count: #{line.to_i} Running Count: #{total_sum}"
    end
  end
   puts "TOTAL_SUM #{total_sum}"
  total_sum
end