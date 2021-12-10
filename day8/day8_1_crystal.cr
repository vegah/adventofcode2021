file_content = File.read("data.txt")
sum = 0
file_content.each_line do |line|
    line_parts = line.split('|')
    digits_parts = line_parts[1].split()
    sum+=digits_parts.count  { |x| [2,3,4,7].any?(x.size) }        
end
puts sum;