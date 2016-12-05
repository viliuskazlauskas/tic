import Test.Hspec
import Data.Maybe

import Winner
import Moves

main :: IO ()
main = hspec $ do
	describe "Strategy" $ do
		it "returns that player 1 won" $ do
			winner [(0,0,'x'),(1,0,'o'),(0,1,'x'),(1,1,'o'),(0,2,'x')] `shouldBe` Just 'x'

		it "returns move Maybe (1,2,'x')" $ do
			head (doMove [(0,0,'x'),(1,0,'o'),(0,1,'x'),(1,1,'o')] 'o') `shouldBe` Just (1,2,'x')