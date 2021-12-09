f = open("./data.txt");
line = readline(f);
sorted_numbers = sort(map(x -> parse(Int32, x),split(line,",")));
middle_value = convert(Int32,size(sorted_numbers)[1]/2);
position = sorted_numbers[middle_value];
print(sum(map(x -> abs(position-x),sorted_numbers)));

