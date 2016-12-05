module Parser
where

parse :: String -> [(Int, Int, Char)]
parse ('L':'i':'s':'t':'(':rest) = reverse $ parseTuples [] rest
parse _ = error "Ne sarasas"

readDigit :: Char -> Int
readDigit '0' = 0
readDigit '1' = 1
readDigit '2' = 2
readDigit _ = error "Digit expected" 

readSeparator :: String -> String
readSeparator (',':rest) = rest
readSeparator (')':rest) = (')':rest)
readSeparator _ = error "Separator expected"

readSpace :: String -> String
readSpace (' ':rest) = readSpace rest
readSpace (x:rest) = x : rest

readKey :: String -> (Char, String)
readKey (x:rest) = (x, rest)

readValue :: String -> (Char, String)
readValue ('0':rest) = ('0', rest)
readValue ('1':rest) = ('1', rest)
readValue ('2':rest) = ('2', rest)
readValue ('x':rest) = ('x', rest)
readValue ('o':rest) = ('o', rest)
readValue _ = error "Value expected"

extractValue :: Char -> Char -> Char -> Char -> Char -> Char -> Char -> Char
extractValue key key1 value1 key2 value2 key3 value3
	| key == key1 = value1
	| key == key2 = value2
	| key == key3 = value3
	| otherwise   = error "No such key"

parseTuples acc ")" = acc
parseTuples acc rest =
  let
    (tuple, restt) = parseTuple rest
    sepRest = readSeparator restt
    spaceRest = readSpace sepRest
  in
    parseTuples (tuple:acc) spaceRest

parseTuple :: String 
           -> ((Int, Int, Char), String) -- ^ result
parseTuple ('L':'i':'s':'t':'(':rest) =
  let
  	(key1, restKey1) = readKey rest
  	sepRest1 = readSeparator restKey1
  	spaceRest11 = readSpace sepRest1
  	(value1, restValue1) =  readValue spaceRest11
  	sepRest11 = readSeparator restValue1

  	spaceRest2 = readSpace sepRest11
  	(key2, restKey2) = readKey spaceRest2
  	sepRest2 = readSeparator restKey2
  	spaceRest22 = readSpace sepRest2
  	(value2, restValue2) =  readValue spaceRest22
  	sepRest22 = readSeparator restValue2

  	spaceRest3 = readSpace sepRest22
  	(key3, restKey3) = readKey spaceRest3
  	sepRest3 = readSeparator restKey3
  	spaceRest33 = readSpace sepRest3
  	(value3, restValue3) =  readValue spaceRest33

  	xChar = extractValue 'x' key1 value1 key2 value2 key3 value3
  	x = readDigit xChar
  	yChar = extractValue 'y' key1 value1 key2 value2 key3 value3
  	y = readDigit yChar
  	p = extractValue 'v' key1 value1 key2 value2 key3 value3
  in
    case restValue3 of
      (')':t) -> ((x, y, p), t)
      _       -> error "Tuple without closing bracket"