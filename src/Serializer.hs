module Serializer
where

serialize :: [(Int, Int, Char)] -> String
serialize board
	| length board == 0 = "List()"
	| length board <= 9 = "List(" ++ serializeMoves board "" ++ ")"
	| otherwise = error "Can not serialize"

serializeMoves :: [(Int, Int, Char)] -> String -> String
serializeMoves (move : tail) acc =
	if 	tail == []
		then serializeMoves tail (acc ++ serializeMove move)
		else serializeMoves tail (acc ++ serializeMove move ++ ",")
serializeMoves [] acc = acc

serializeMove :: (Int, Int, Char) -> String
serializeMove (x,y,v) = "List(x, " ++ (show x) ++ ", y, " ++ (show y) ++ ", v, " ++ [v] ++ ")" 