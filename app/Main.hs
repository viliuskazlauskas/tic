module Main where

import Parser
import Moves
import Serializer
import Winner

import Data.Aeson
import Network.HTTP.Client
import Data.ByteString.Char8(pack)
import qualified Data.ByteString.Lazy.Char8 as Lazy
import qualified Data.CaseInsensitive as CI

headers = [
    (CI.mk $ pack "Content-Type", pack "application/scala+list"),
    (CI.mk $ pack "Accept", pack "application/scala+list")
  ]

main :: IO ()
main = do
	putStrLn "Enter game ID: "
	gameId <- getLine
	putStrLn "Enter player ID: "
	playerId <- getLine
	let url = "http://tictactoe.homedir.eu/game/" ++ gameId ++ "/player/" ++ playerId

	case playerId of
		"1" -> postMethod playerId url []
		"2" -> getMethod playerId url
		_ -> error "Bad player ID"

postMethod :: String -> String -> [(Int, Int, Char)] -> IO ()
postMethod playerId url board = do
	let playerMark = getPlayerMark playerId
	let playerMove = move (getPlayerMark playerId) (getEnemyMark playerId) board
	{-let serializedMove = serialize playerMove-}

	let board2 = case playerMove of
		Nothing -> board
		Just (x,y,v) -> board ++ [(x,y,v)]

	let serializedBoard = serialize board2

	manager <- newManager defaultManagerSettings
 	initialRequest <- parseRequest $ url
 	let request = initialRequest {
		method = pack "POST",
		requestHeaders = headers,
		requestBody = RequestBodyLBS $ Lazy.pack serializedBoard
	}

	response <- httpLbs request manager
	putStrLn $ "The status code was: " ++ (show $ responseStatus response)
	print $ responseBody response

	afterPost playerId url board2

afterPost :: String -> String -> [(Int, Int, Char)] -> IO ()
afterPost playerId url board
	| win == Just 'x' = putStrLn "Winner is Player 1"
	| win == Just '0' = putStrLn "Winner is Player 2"
	| win == Nothing && length board == 9 = putStrLn "Draw"
	| win == Nothing && length board < 9 = getMethod playerId url
	| otherwise = error "Something unexpected happen"
	where
		win = winner board

getMethod :: String -> String -> IO ()
getMethod playerId url = do
	manager <- newManager defaultManagerSettings
	initialRequest <- parseRequest $ url
	let request = initialRequest { requestHeaders = headers }
	response <- httpLbs request manager
	let body = responseBody response

	putStrLn $ "The status code was: " ++ (show $ responseStatus response)
	print body

	let receivedBoard = parse $ Lazy.unpack body

	afterGet playerId url receivedBoard

afterGet :: String -> String -> [(Int, Int, Char)] -> IO ()
afterGet playerId url board
	| win == Just 'x' = putStrLn "Winner is Player 1"
	| win == Just '0' = putStrLn "Winner is Player 2"
	| win == Nothing && length board == 9 = putStrLn "Draw"
	| win == Nothing && length board < 9 = postMethod playerId url board
	| otherwise = error "Something unexpected happen"
	where
		win = winner board

printas :: Maybe (Int, Int, Char) -> IO ()
printas abc = case abc of 
	Nothing -> putStrLn "Nieko"
	Just (a,b,c) -> putStrLn ("x: " ++ (show a) ++ " y: " ++ (show b) ++ " value: " ++ (show c))

printas3 :: String -> IO ()
printas3 msg
	| win == Nothing = putStrLn "Niekas"
	| win == Just 'x' = putStrLn "X as"
	| win == Just 'o' = putStrLn "O as"
	| otherwise = error "Xuine"
	where
		win = winner (parse msg)

message :: String
message = "List(List(x,  0, y, 2,  v,  x),   List(x,   2, y,   1,   v, o),  List(x, 0,   y,  0,  v,  x),   List(x, 1, y,  2,   v, o),  List(x, 2,  y,   2, v, x))"

move :: Char -> Char -> [(Int, Int, Char)] -> Maybe (Int, Int, Char)
move playerMark enemyMark board
	| board == [] = Just (0,0,playerMark)
	| length board < 9 = head (doMove board playerMark)
	| otherwise = Nothing
	where
		moves = doMove board enemyMark
		moves2 = moves ++ (doMove board playerMark)

currentPlayer :: (Int, Int, Char) -> Char
currentPlayer (x,y,v)
	| v == 'x' = 'o'
	| v == 'o' = 'x'
	| otherwise = error "No such player"

getPlayerMark :: String -> Char
getPlayerMark "1" = 'x'
getPlayerMark "2" = 'o'

getEnemyMark :: String -> Char
getEnemyMark "1" = 'o'
getEnemyMark "2" = 'x'
