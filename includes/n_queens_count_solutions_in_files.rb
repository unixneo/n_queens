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