module Main where

import Prelude
import Data.Unrestricted.Linear
import qualified Foreign.Marshal.Pure as Manual

main :: IO ()
main = print "hi"
  -- (Ur res) <- pure $ Manual.withPool nothingWith3
  -- print @Int res

-- nothingWith3 :: Manual.Pool %1-> Ur Int
-- nothingWith3 pool = do
--   int <- move $ Manual.alloc 3 pool
--   move (Manual.deconstruct $ unur int)


f :: a %1 -> a
f a = a

-- g :: (a -> b) %1 -> a -> (b, a)
-- g f a = (f a, a)

-- withTuple
--   :: (a %1 -> b) %1
--   -> (a, a) %1
--   -> (b, a)
-- withTuple f t = (f a1, a2)
--   where
--     (a1, a2) = t

withTuple
  :: (a %1 -> b) %1
  -> (a, a) %1
  -> (b, a)
withTuple f (a1, a2) = (f a1, a2)
