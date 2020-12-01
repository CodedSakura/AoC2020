with open("./input.txt") as f:
    arr = [int(i) for i in f.readlines()]
    for i in arr:
        for j in arr:
            for k in arr:
                if i + j + k == 2020:
                    print(i * j * k)
                    break
