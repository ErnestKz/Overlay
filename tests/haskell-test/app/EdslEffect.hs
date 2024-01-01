module EdslEffect where

import Prelude

import Data.Kind

import Effectful
import Effectful.Dispatch.Dynamic
import Effectful.TH

import Data.Functor.Identity qualified as Functor


data family Haskell a
newtype instance Haskell a = Haskell { unHaskell :: a }
  deriving Show
  deriving Functor via Functor.Identity
  deriving Applicative via Functor.Identity

data Action rep :: Effect where
  Val :: Action rep m (rep Int)
  Mul :: rep Int -> rep Int -> Action rep m (rep Int)
makeEffect ''Action

data Lambda rep :: Effect where
  Lam :: m (rep a -> rep b) -> Lambda rep m (rep (a -> b))
makeEffect ''Lambda

data Condition rep :: Effect where  
  IsEven :: rep Int -> Condition rep m (rep Bool)
makeEffect ''Condition

data Control rep :: Effect where
  IfElse :: rep Bool -> m a -> m a -> Control rep m a
makeEffect ''Control


runPureAction
  :: Eff (Action Haskell : es) a
  -> Eff es a 
runPureAction = interpret $ \_env -> \case
  Val -> pure $ pure 3
  Mul i1 i2 -> pure $ (*) <$> i1 <*> i2

runPureCondition
  :: Eff (Condition Haskell : es) a
  -> Eff es a 
runPureCondition = interpret $ \_env -> \case
  IsEven int -> pure $ even <$> int

runPureLambda
  :: Eff (Lambda Haskell : es) a
  -> Eff es a
runPureLambda = interpret $ \env -> \case
  Lam lambda -> do
    lambda' <- go lambda
    pure $ pure $ unHaskell . lambda' . pure
      where
        go m = localSeqUnlift env (\t -> t m)

runPureControl
  :: Eff (Control Haskell : es) a
  -> Eff es a 
runPureControl = interpret $ \env -> \case
  IfElse (Haskell b) m1 m2 -> if b then go m1 else go m2
    where
      go m = localSeqUnlift env (\t -> t m)

      
program
  :: ( Action rep :> es
     , Condition rep :> es
     , Lambda rep :> es
     , Control rep :> es )
  => Eff es (rep Int)
program = do
  a <- val
  b <- val
  aEven <- isEven a
  -- c <- lam $ do
  --   mulNum <- mul
  --   pure \num -> num
  res <- ifElse aEven
    (mul a a)
    (mul b b)
  pure res
  
main :: IO ()
main = print
  $ runPureEff
  $ runPureControl
  $ runPureCondition
  $ runPureAction
  $ runPureLambda
  $ program


-- runPureControl
--   :: Eff ((Control Haskell) : es) a
--   -> Eff es a 
-- runPureControl = interpret $ \env -> \case
--   IfElse bool m1 m2 -> if bool then go m1 else go m2
--     where
--       go m = localSeqUnlift env (\t -> t m)


  
-- runPureAction
--   :: Eff ((Action Haskell) : es) a
--   -> Eff es a 
-- runPureAction = interpret $ \_env -> \case
--   Val -> pure $ 3
--   Mul i1 i2 -> pure $ i1 * i2

---- 

-- data Haskell

-- type Rep :: Type -> k -> k
-- type family Rep rep t = t' | t' -> t

-- type instance Rep Haskell Bool = Bool
-- type instance Rep Haskell Int = Int
-- type instance Rep Haskell (->) = (->)


-- data Action (rep :: Type -> Type) :: Effect where
--   Val :: Action rep m (Rep rep Int)
--   Mul :: Rep rep Int -> Rep rep Int -> Action rep m (Rep rep Int)
-- makeEffect ''Action

-- data Lambda rep :: Effect where
--   Lam :: (Rep rep a -> Rep rep b) -> Lambda rep m (Rep rep (a -> b))
-- makeEffect ''Lambda

-- data Condition rep :: Effect where  
--   IsEven :: Rep rep Int -> Condition rep m (Rep rep Bool)
-- makeEffect ''Condition

-- data Control rep :: Effect where
--   IfElse :: Rep rep Bool -> m a -> m a -> Control rep m a
-- makeEffect ''Control

-- runPureLambda
--   :: Eff ((Lambda Haskell) : es) a
--   -> Eff es a
-- runPureLambda = interpret $ \_env -> \case
--   Lam lambda -> pure $ lambda
  
-- runPureControl
--   :: Eff ((Control Haskell) : es) a
--   -> Eff es a 
-- runPureControl = interpret $ \env -> \case
--   IfElse bool m1 m2 -> if bool then go m1 else go m2
--     where
--       go m = localSeqUnlift env (\t -> t m)

-- runPureCondition
--   :: Eff ((Condition Haskell) : es) a
--   -> Eff es a 
-- runPureCondition = interpret $ \_env -> \case
--   IsEven int -> pure $ int `mod` 2 == 0
  
-- runPureAction
--   :: Eff ((Action Haskell) : es) a
--   -> Eff es a 
-- runPureAction = interpret $ \_env -> \case
--   Val -> pure $ 3
--   Mul i1 i2 -> pure $ i1 * i2
