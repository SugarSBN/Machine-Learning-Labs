module Main where

import Data.Tree
import Data.CSV
import Data.List
import Text.ParserCombinators.Parsec

data Class2Set = Class2Set {
    features :: [[Double]],
    labels   :: [Integer]
}

data DataSet = DataSet {
    trainingSet :: Class2Set,
    testSet     :: Class2Set
}

readCSV :: String -> IO ([String], [[Double]])
readCSV filename = do
    input <- readFile filename
    case parse csvFile filename input of
        Left e -> do
            putStrLn "Error parsing input:"
            print e
            return ([], [])
        Right r -> return $ (head r, map (map read) (tail r))

matrix2Set :: [[Double]] -> Class2Set
matrix2Set mat = Class2Set [[mat !! i !! j | j <- [0 .. (n - 2)]] | i <- [0 .. (m - 1)]] 
                           [floor (mat !! i !! (n - 1)) | i <- [0 .. (m - 1)]]
    where
        m = length mat
        n = length (head mat)

set2Matrix :: Class2Set -> [[Double]]
set2Matrix (Class2Set features labels) = [[features !! i !! j | j <- [0 .. (n - 1)]] ++ [fromIntegral (labels !! i)] | i <- [0 .. (m - 1)]]
    where
        (m, n) = (length features, length (head features))

toStringTree :: Show a => Tree a -> Tree String
toStringTree (Node a b) = Node (show a) (map toStringTree b)

main :: IO ()
main = do
    (csvTitle, csvData') <- readCSV "./ex6Data/ex6Data.csv"
    let csvData = take 110 csvData'
    print $ length csvData
    let (m, n) = (length csvData, length (head csvData))
    let (testSet', trainingSet') = splitAt 10 csvData
    let (testSet, trainingSet) = (matrix2Set testSet', matrix2Set trainingSet')
    let dataSet = DataSet trainingSet testSet
    
    t <- genTree trainingSet csvTitle
    putStrLn $ (drawTree . toStringTree) t
    print $ Main.labels testSet
    print $ map (\s -> predict s t) (Main.features testSet)
    print $ (fromIntegral (length (filter (\(a, b) -> a == b) (zip (Main.labels testSet) (map (\s -> predict s t) (Main.features testSet)))))) / 
            (fromIntegral (length (Main.labels testSet)))


data Judgement = Judgement String Int Double
instance Show Judgement where
    show (Judgement name id val) = name ++ " ?< " ++ show val

splitJudgement :: Judgement -> Class2Set -> (Class2Set, Class2Set)
splitJudgement (Judgement name id val) class2Set = 
    (matrix2Set (filter (\x -> x !! id < val) (set2Matrix class2Set)),
     matrix2Set (filter (\x -> x !! id >= val) (set2Matrix class2Set)))

gini :: Class2Set -> Double
gini (Class2Set features labels) = 1.0 - 
                                    ((fromIntegral (length (filter (== 0) labels))) / fromIntegral (length labels)) ^ 2 - 
                                    ((fromIntegral (length (filter (== 1) labels))) / fromIntegral (length labels)) ^ 2

giniA :: Class2Set -> Judgement -> Double
giniA class2Set judgement = 
    let (leftSet, rightSet) = splitJudgement judgement class2Set
        (m, n) = (length (set2Matrix class2Set), length (head (set2Matrix class2Set)))
        (m1, m2) = (length (set2Matrix leftSet), length (set2Matrix rightSet))
    in (fromIntegral m1 / fromIntegral m) * (gini leftSet) + (fromIntegral m2 / fromIntegral m) * (gini rightSet)


genJudgement :: Class2Set -> [String] -> [[Judgement]]
genJudgement (Class2Set features labels) titles =
    [   [Judgement (titles !! i) i (features' !! i !! j + 0.00005) | j <- [0 .. (m - 2)]]
        | i <- [0 .. (n - 1)]]
    where
        (m, n) = (length features, length (head features)) 
        features' = map sort [ [features !! j !! i | j <- [0 .. (m - 1)]] | i <- [0 .. (n - 1)]]

genTree :: Class2Set -> [String] -> IO (Tree Judgement)
genTree class2Set titles = do
    if ((all (== 0) (Main.labels class2Set)) || (all (== 1) (Main.labels class2Set))) 
        then 
            return $ Node (Judgement "" 0 (fromIntegral (head (Main.labels class2Set)))) []
        else do 
            let (m, n) = (length (features class2Set), length (head (features class2Set)))
            let judgements = genJudgement class2Set titles
            let ginis = map (map (giniA class2Set)) judgements
            let ginis' = [[(ginis !! i !! j, i, j) | j <- [0 .. (m - 2)]] | i <- [0 .. (n - 1)]]
            let (mins, mini, minj) = minimum (concat ginis')
            let minjudgement = judgements !! mini !! minj
            let (left, right) = splitJudgement minjudgement class2Set
            lft <- genTree left titles
            rig <- genTree right titles
            return $ Node minjudgement [lft, rig]


predict :: [Double] -> Tree Judgement -> Integer
predict features (Node (Judgement name id val) []) = floor val
predict features (Node (Judgement name id val) [lft, rig]) = 
    if (features !! id < val) 
        then predict features lft
        else predict features rig