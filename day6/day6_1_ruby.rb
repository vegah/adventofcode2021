file = File.open("data.txt")
data = file.read
current_state = Array.new(9) { |i| 0}
start_state = data.split(',')
for fish in start_state
   current_state[fish.to_i]+=1 
end

days_to_run = 80

for i in 1..days_to_run
    should_be_reborn = current_state[0]
    current_state[0] = 0
    current_state = current_state.rotate(1) # Move everything to the left
    current_state[6]+=should_be_reborn
    current_state[8]=should_be_reborn
end

print current_state.sum()