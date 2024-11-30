
directory_path = 'solutions_20_20241014_135708'
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
      total_sum += line.to_i
      puts "FILE PATH #{file_path} Count: #{line.to_i} Running Count: #{total_sum}"
    end
  end
   puts "TOTAL_SUM #{total_sum}"
  total_sum
end

get_total_counts_from_files(directory_path)
