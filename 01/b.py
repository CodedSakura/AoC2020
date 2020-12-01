with open("./input.txt") as f:
    arr = [int(i) for i in f.readlines()]
    for i in range(len(arr)-2):
        for j in range(i+1, len(arr)-1):
            for k in range(j+1, len(arr)):
                if arr[i] + arr[j] + arr[k] == 2020:
                    print(arr[i] * arr[j] * arr[k])
