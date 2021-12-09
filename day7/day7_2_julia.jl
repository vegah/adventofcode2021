f = open("./realdata.txt");
line = readline(f);
numbers = map(x -> parse(Int32, x),split(line,","));
min = minimum(numbers);
max = maximum(numbers);
best = convert(Int64,(max*(max+1))/2*max);  # Initialize a "worst case" best value 
for i in min:max
   test = convert(Int64,sum(map(x -> abs(i-x)*(abs(i-x)+1)/2,numbers)));
   global best = minimum((best,test));
end
print(best);
