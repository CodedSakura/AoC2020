with open("./input.txt") as f:
    arr = [int(i) for i in f.readlines()]
    for i in arr:
        for j in arr:
            if i + j == 2020:
                print(i * j)
                break
