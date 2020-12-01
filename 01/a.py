with open("./input.txt") as f:
    arr = [int(i) for i in f.readlines()]
    for i in range(len(arr)-1):
        for j in range(i+1, len(arr)):
            if arr[i] + arr[j] == 2020:
                print(arr[i] * arr[j])
                break
