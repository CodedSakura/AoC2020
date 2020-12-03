package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	product := 1
	for _, diff := range [][]int{{1, 1}, {1, 3}, {1, 5}, {1, 7}, {2, 1}} {
		pos := [2]int{0, 0}
		treeCounter := 0
		for pos[0] < len(lines) {
			line := lines[pos[0]]
			if line[pos[1]%len(line)] == '#' {
				treeCounter += 1
			}
			pos[0] += diff[0]
			pos[1] += diff[1]
		}
		fmt.Println(treeCounter)
		product *= treeCounter
	}
	fmt.Println(product)

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
