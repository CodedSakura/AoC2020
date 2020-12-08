data <- read.delim("input.txt", sep=" ", header = FALSE, stringsAsFactors = FALSE)
data$visited = FALSE
acc = 0
i = 1
while (TRUE) {
  if (isTRUE(data$visited[i])) break
  data$visited[i] = TRUE
  ins = data$V1[i]
  op = data$V2[i]
  if (ins == "acc") {
    acc = acc + op
    i = i+1
  } else if (ins == "nop") {
    i = i+1
  } else if (ins == "jmp") {
    i = i+op
  }
}
print(acc)