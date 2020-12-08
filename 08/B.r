origdata <- read.delim("input.txt", sep=" ", header = FALSE, stringsAsFactors = FALSE)
counts <- table(unlist(origdata$V1))
check <- function (changeIndex, changeValue) {
  data <- data.frame(origdata)
  data$V1[changeIndex] = changeValue
  data$visited = 0
  acc = 0
  i = 1
  while (TRUE) {
    if (data$visited[i] > 2) break
    data$visited[i] = data$visited[i] + 1
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
    if (i > length(data$V1)) {
      return(acc)
    }
  }
}
for (i in which(origdata == "nop")) {
  if (!is.null(v <- check(i, "jmp"))) {
    print(v)
  }
}
for (i in which(origdata == "jmp")) {
  if (!is.null(v <- check(i, "nop"))) {
    print(v)
  }
}