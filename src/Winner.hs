module Winner
where

winner :: [(Int, Int, Char)] -> Maybe Char
winner board
		 | length (filterLine (filterXMoves board) 0) == 3 = Just 'x'
		 | length (filterLine (filterXMoves board) 1) == 3 = Just 'x'
		 | length (filterLine (filterXMoves board) 2) == 3 = Just 'x'
		 | length (filterLine (filterOMoves board) 0) == 3 = Just 'o'
		 | length (filterLine (filterOMoves board) 1) == 3 = Just 'o'
		 | length (filterLine (filterOMoves board) 2) == 3 = Just 'o'
		 | length (filterColumn (filterXMoves board) 0) == 3 = Just 'x'
		 | length (filterColumn (filterXMoves board) 1) == 3 = Just 'x'
		 | length (filterColumn (filterXMoves board) 2) == 3 = Just 'x'
		 | length (filterColumn (filterOMoves board) 0) == 3 = Just 'o'
		 | length (filterColumn (filterOMoves board) 1) == 3 = Just 'o'
		 | length (filterColumn (filterOMoves board) 2) == 3 = Just 'o'
		 | length (filterFirstDiagonal (filterXMoves board)) == 3 = Just 'x'
		 | length (filterSecondDiagonal (filterXMoves board)) == 3 = Just 'x'
		 | length (filterFirstDiagonal (filterOMoves board)) == 3 = Just 'o'
		 | length (filterSecondDiagonal (filterOMoves board)) == 3 = Just 'o'
		 | otherwise = Nothing

filterXMoves :: [(Int, Int, Char)] -> [(Int, Int, Char)]
filterXMoves moves = filter (\(_,_,p) -> p == 'x' || p == 'X') moves

filterOMoves :: [(Int, Int, Char)] -> [(Int, Int, Char)]
filterOMoves moves = filter (\(_,_,p) -> p == 'o' || p == 'O') moves

filterLine :: [(Int, Int, Char)] -> Int -> [(Int, Int, Char)]
filterLine moves nr = filter (\(x,_,_) -> x == nr) moves

filterColumn :: [(Int, Int, Char)] -> Int -> [(Int, Int, Char)]
filterColumn moves nr = filter (\(_,y,_) -> y == nr) moves

filterFirstDiagonal :: [(Int, Int, Char)] -> [(Int, Int, Char)]
filterFirstDiagonal moves = filter (\(x,y,_) -> y == x) moves

filterSecondDiagonal :: [(Int, Int, Char)] -> [(Int, Int, Char)]
filterSecondDiagonal moves = filter (\(x,y,_) -> y + x == 2) moves