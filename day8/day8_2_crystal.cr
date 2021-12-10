file_content = File.read("realdata.txt")
sum = 0
file_content.each_line do |line|
    line_parts = line.split('|')
    # line_parts = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf".split('|')
    unique_signal = line_parts[0].split()
    hash = create_map(unique_signal)
    digits = create_digits(line_parts[1].split(),hash)
    sum = sum + digits.to_i
end
print sum

def create_digits(digits, hash) 
    sum = ""
    digits.each do |digit| 
        if (digit.size==5) 
            sum=sum+decodeFive(digit,hash)
        elsif (digit.size==6) 
            sum=sum+decodeSix(digit,hash)
        elsif (digit.size==2)
            sum=sum+"1"
        elsif (digit.size==3)
            sum=sum+"7"
        elsif (digit.size==7)
            sum=sum+"8"
        elsif (digit.size==4)
            sum=sum+"4"
        end
    end
    return sum+"\n"
end

def decodeSix(digit,hash)
    if (digit.count &.in?([hash['e'],hash['d']]) == 2) 
        return "6";
    elsif (digit.count &.in?([hash['c'],hash['d']]) == 2) 
        return "9";
    else
        return "0"
    end
end

def decodeFive(digit,hash)
    if (digit.count &.in?([hash['b'],hash['f']]) == 2) 
        return "5";
    elsif (digit.count &.in?([hash['c'],hash['f']]) == 2)
        return "3"
    elsif (digit.count &.in?([hash['c'],hash['e']]) == 2)
        return "2"
    end
    return ""
end


def create_map(unique_signal)
    hash = Hash(Char,Char).new
    # First find seven
    seven = unique_signal.find("BLAH") {|x| x.size==3}
    one = unique_signal.find("BLAH") {|x| x.size==2}
    hash['a'] = seven.chars.reject { |x| one.includes?(x)}.first()
    four = unique_signal.find("BLAH") {|x| x.size==4}
    d_or_b = four.chars.reject { |x| one.chars.includes?(x)}
    zero_six_or_nine = unique_signal.select {|x| x.size==6}
    zero = zero_six_or_nine.find("BLAH") {|x| x.count &.in?(d_or_b)==1}
    hash['d'] = d_or_b.reject {|x| zero.includes?(x)}.first()
    hash['b'] = d_or_b.reject(hash['d']).first()

    nine = zero_six_or_nine.reject(zero).find("BLAH") { |x| x.count &.in?(one.chars)==2}
    six = zero_six_or_nine.reject(zero).reject(nine).first()
    hash['e'] = six.chars.reject { |x| x.in?(nine.chars)}.first()
    hash['c'] = nine.chars.reject { |x| x.in?(six.chars)}.first()
    hash['f'] = one.chars.reject(hash['c']).first()
    return hash
    # print sixornine;
end