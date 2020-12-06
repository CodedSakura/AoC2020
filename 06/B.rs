use std::io::{BufReader, BufRead};
use std::fs::File;
use std::collections::HashSet;
use std::iter::FromIterator;

fn main() {
    let reader = BufReader::new(File::open("./input.txt").unwrap());

    let mut sum = 0;
    let mut answers: Vec<HashSet<char>> = Vec::new();
    for line in reader.lines() {
        let line = line.unwrap();
        if line.is_empty() {
            let mut res = HashSet::<char>::from_iter("abcdefghijklmnopqrstuvwxyz".chars());
            for x in answers.iter() {
                res = x.iter().filter_map(|v| res.take(v)).collect();
            }
            sum += res.len();
            answers.clear();
        } else {
            answers.push(HashSet::from_iter(line.chars().filter(|v| v.is_alphanumeric())));
        }
    }
    let mut res = HashSet::<char>::from_iter("abcdefghijklmnopqrstuvwxyz".chars());
    for x in answers.iter() {
        res = x.iter().filter_map(|v| res.take(v)).collect();
    }
    sum += res.len();
    print!("{}", sum);
}