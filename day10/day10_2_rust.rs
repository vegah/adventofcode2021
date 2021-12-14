use std::fs;
use std::collections::HashMap;

fn main() {
   let mut data = fs::read_to_string("realdata.txt")
        .expect("Error reading file")
        .lines()
        .map(|x| score_string(x))
        .filter(|x| *x!=0)
        .collect::<Vec<_>>();
    data.sort();

    print!("{}",data[data.len()/2]);

}

fn score_string(str : &str) -> u64 {
    let scores  = HashMap::from([
        ('(', 1),
        ('[', 2),
        ('{', 3),
        ('<', 4),
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
                return 0;
            }
        }
    }
    let val = stack.iter().rev().fold(0,|acc,x| {
        let mut new = acc*5;
        let sum_for_char = scores.get(x).unwrap();
        new+=sum_for_char;
        return new;
    });

    return val;
}