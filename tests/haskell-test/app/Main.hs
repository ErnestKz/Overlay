module Main where

import Data.Kind

import Effectful
import Effectful.Dispatch.Dynamic
import Effectful.TH

data Haskell

type Rep :: Type -> Type -> Type
type family Rep rep t = t' | t' -> t

type instance Rep Haskell Bool = Bool
type instance Rep Haskell Int = Int

data Action rep :: Effect where
  Val :: Action rep m (Rep rep Int)
  Mul :: Rep rep Int -> Rep rep Int -> Action rep m (Rep rep Int)
makeEffect ''Action

data Condition rep :: Effect where  
  IsEven :: Rep rep Int -> Condition rep m (Rep rep Bool)
makeEffect ''Condition

data Control rep :: Effect where
  IfElse :: Rep rep Bool -> m a -> m a -> Control rep m a
makeEffect ''Control

main :: IO ()
main = print
  $ runPureEff
  $ runPureControl
  $ runPureCondition
  $ runPureAction
  $ program

runPureControl
  :: Eff ((Control Haskell) : es) a
  -> Eff es a 
runPureControl = interpret $ \env -> \case
  IfElse bool m1 m2 -> if bool then go m1 else go m2
    where
      go m = localSeqUnlift env (\t -> t m)

runPureCondition
  :: Eff ((Condition Haskell) : es) a
  -> Eff es a 
runPureCondition = interpret $ \_env -> \case
  IsEven int -> pure $ int `mod` 2 == 0
  
runPureAction
  :: Eff ((Action Haskell) : es) a
  -> Eff es a 
runPureAction = interpret $ \_env -> \case
  Val -> pure $ 3
  Mul i1 i2 -> pure $ i1 * i2
  
program
  :: ( Action rep :> es
     , Condition rep :> es
     , Control rep :> es )
  => Eff es (Rep rep Int)
program = do
  a <- val
  b <- val
  aEven <- isEven a
  res <- ifElse aEven
    (mul a a)
    (mul b b)
  pure res


