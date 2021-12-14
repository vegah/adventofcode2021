use std::fs;
use std::collections::HashMap;


fn main() {
   let data = fs::read_to_string("data.txt")
        .expect("Error reading file")
        .lines()
        .map(|x| score_string(x))
        .collect::<Vec<_>>();

        print!("Sum : {}",data.iter().sum::<u32>());
}

fn score_string(str : &str) -> u32 {
    let scores  = HashMap::from([
        (')', 3),
        (']', 57),
        ('}', 1197),
        ('>', 25137),
    ]);

    let opposing  = HashMap::from([
        (')', '('),
        (']', '['),
        ('}', '{'),
        ('>', '<'),
    ]);

    
    let mut stack : Vec<char> = Vec::new();
    for c in str.chars() {
        if "{[<(".contains(c) {
            stack.push(c);
        } else {
            let last = stack.pop().unwrap();
            let opposed = opposing.get(&c).unwrap();
            if last!=*opposed {
                let val = scores.get(&c).unwrap();
               return *val;
            }
        }
    }
    return 0;
}