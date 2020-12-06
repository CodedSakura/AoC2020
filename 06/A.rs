use std::io::{BufReader, BufRead};
use std::fs::File;
use std::collections::HashSet;

fn main() {
    let reader = BufReader::new(File::open("./input.txt").unwrap());

    let mut sum = 0;
    let mut answers = HashSet::new();
    for line in reader.lines() {
        let line = line.unwrap();
        if line.is_empty() {
            sum += answers.len();
            answers.clear();
        }
        for c in line.chars() {
            answers.insert(c);
        }
    }
    sum += answers.len();
    answers.clear();
    print!("{}", sum);
}