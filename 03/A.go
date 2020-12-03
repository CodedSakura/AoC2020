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

	pos := [2]int{0, 0}
	treeCounter := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := scanner.Text()
		if text[pos[1]%len(text)] == '#' {
			treeCounter += 1
		}
		pos[0] += 1
		pos[1] += 3
	}
	fmt.Println(treeCounter)

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
