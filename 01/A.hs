subsets 0 _ = [[]]
subsets _ [] = []
subsets n (x : xs) = map (x :) (subsets (n - 1) xs) ++ subsets n xs

main = do
    contents <- fmap lines $ readFile "input.txt"
    let d = map read contents :: [Int]
    print $ [product x | x <- subsets 2 d, sum x == 2020] !! 0