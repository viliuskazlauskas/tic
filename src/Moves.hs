module Moves
where
import Data.List


doMove :: [(Int, Int, Char)] -> Char -> [Maybe (Int, Int, Char)]
doMove board player =
	let
		possibleMoves0 = doMoveLine board 0 player
		possibleMoves1 = possibleMoves0 ++ doMoveLine board 1 player
		possibleMoves2 = possibleMoves1 ++ doMoveLine board 2 player

		possibleMoves3 = possibleMoves2 ++ doMoveRow board 0 player
		possibleMoves4 = possibleMoves3 ++ doMoveRow board 1 player
		possibleMoves5 = possibleMoves4 ++ doMoveRow board 2 player

		possibleMoves6 = possibleMoves5 ++ doMoveDiagonal1 board player
		possibleMoves7 = possibleMoves6 ++ doMoveDiagonal2 board player

		possibleMoves8 = possibleMoves7 ++ doMoveEmpty board player
	in
		possibleMoves8

doMoveLine :: [(Int, Int, Char)] -> Int -> Char -> [Maybe (Int, Int, Char)]
doMoveLine board line player
	| movesCount == 2 && enemieMovesCount == 2 = [Just (line, (giveMove enemieMoves), player)]
	| otherwise = []
	where
		enemieMovesLine = filterLine board line
		enemieMoves = findEnemyMovesLine enemieMovesLine player
		movesCount = head enemieMoves
		enemieMovesCount = length (tail enemieMoves)

doMoveRow :: [(Int, Int, Char)] -> Int -> Char -> [Maybe (Int, Int, Char)]
doMoveRow board row player
	| movesCount == 2 && enemieMovesCount == 2 = [Just ((giveMove enemieMoves), row, player)]
	| otherwise = []
	where
		enemieMovesRow = filterRow board row
		enemieMoves = findEnemyMovesRow enemieMovesRow player
		movesCount = head enemieMoves
		enemieMovesCount = length (tail enemieMoves)

doMoveDiagonal1 :: [(Int, Int, Char)] -> Char -> [Maybe (Int, Int, Char)]
doMoveDiagonal1 board player
	| movesCount == 2 && enemieMovesCount == 2 = [Just (giveMoveDiagonal enemieMoves player)]
	| otherwise = []
	where
		enemieMovesDiagonal = filterDiagonal1 board
		enemieMoves = findEnemyMovesDiagonal enemieMovesDiagonal player
		movesCount = head enemieMoves
		enemieMovesCount = length (tail enemieMoves)

doMoveDiagonal2 :: [(Int, Int, Char)] -> Char -> [Maybe (Int, Int, Char)]
doMoveDiagonal2 board player
	| movesCount == 2 && enemieMovesCount == 2 = [Just (giveMoveDiagonal enemieMoves player)]
	| otherwise = []
	where
		enemieMovesDiagonal = filterDiagonal2 board
		enemieMoves = findEnemyMovesDiagonal enemieMovesDiagonal player
		movesCount = head enemieMoves
		enemieMovesCount = length (tail enemieMoves)

doMoveEmpty :: [(Int, Int, Char)] -> Char -> [Maybe (Int, Int, Char)]
doMoveEmpty board player = map (\(x,y) -> Just (x,y,player)) ([(x,y) | x <- [0..2], y <- [0..2]] \\ map (\(x,y,_) -> (x,y)) board)

giveMove :: [Int] -> Int
giveMove (x:rest) 
	| length m == 1 = head m
	| otherwise = error "Not two enemie moves given"
	where
		m = [0,1,2] \\ rest

giveMoveDiagonal :: [Int] -> Char -> (Int, Int, Char)
giveMoveDiagonal (x:rest) player
	| length m == 1 = (x, 2-x, player)
	| otherwise = error "Not two enemie moves given"
	where
		m = [0,1,2] \\ rest
		x = head m

filterLine :: [(Int, Int, Char)] -> Int -> [(Int, Int, Char)]
filterLine board lineNo = filter (\(x,_,_) -> x == lineNo) board

filterRow :: [(Int, Int, Char)] -> Int -> [(Int, Int, Char)]
filterRow board rowNo = filter (\(_,y,_) -> y == rowNo) board

filterDiagonal1 :: [(Int, Int, Char)] -> [(Int, Int, Char)]
filterDiagonal1 board = filter (\(x,y,_) -> y == x) board

filterDiagonal2 :: [(Int, Int, Char)] -> [(Int, Int, Char)]
filterDiagonal2 board = filter (\(x,y,_) -> y + x == 2) board

findEnemyMovesLine :: [(Int, Int, Char)] -> Char -> [Int]
findEnemyMovesLine line player = foldl findInLineMove [length line] (filterEnemyMoves line player)

findEnemyMovesRow :: [(Int, Int, Char)] -> Char -> [Int]
findEnemyMovesRow row player = foldl findInRowMove [length row] (filterEnemyMoves row player)

findEnemyMovesDiagonal :: [(Int, Int, Char)] -> Char -> [Int]
findEnemyMovesDiagonal diagonal player = foldl findInDiagonalMove [length diagonal] (filterEnemyMoves diagonal player)

filterEnemyMoves :: [(Int, Int, Char)] -> Char -> [(Int, Int, Char)]
filterEnemyMoves line player = filter (\(_,_,p) -> p /= player) line

findInLineMove :: [Int] -> (Int, Int, Char) -> [Int]
findInLineMove array (x,y,p) = array ++ [y]

findInRowMove :: [Int] -> (Int, Int, Char) -> [Int]
findInRowMove array (x,y,p) = array ++ [x]

findInDiagonalMove :: [Int] -> (Int, Int, Char) -> [Int]
findInDiagonalMove array (x,y,p) = array ++ [x]