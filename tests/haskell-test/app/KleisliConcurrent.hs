module Main where

import Prelude hiding ((.), id)
import Control.Category
import Control.Arrow
import Control.Monad
import Control.Monad.IO.Class

import Control.Concurrent
import Control.Concurrent.Async

main :: IO ()
main = do
  num <- runKleisli (collapse g) 0
  print num
  where
    g = addA2
      (actor $ \a -> do
          threadDelay 2000000
          print "A" >> pure a)
  
    
    -- g = addA2
    --   (actor $ \a -> do
    --       threadDelay 2000000
    --       print "From Actor 1"
    --       pure $ length a)
    --   (actor $ \b -> do
    --       threadDelay 200000
    --       print "From Actor 2"
    --       pure $ length b -2 )

addA :: Arrow a => a b Int -> a b Int -> a b Int
addA f g = proc x -> do
  y <- f -< x
  z <- g -< x
  p <- arr (const 3) -< x
  returnA -< y + z + p

actor :: Functor m => (a -> m b) -> KleisliConcurrent m a b
actor = KleisliSingle . Kleisli

-- this one has concurrent behaviour, the above one doesnt
-- this is because the above one probably desugars to use first and second
-- addA2 :: Arrow a => a b Int -> a b Int -> a b Int
-- addA2 f g = arr (\a -> (a,a)) >>> (f *** g) >>> arr (uncurry (+))

addA2
  :: Arrow a
  => a Int Int
  -> a Int Int
addA2 h =
  (h &&& h &&& h &&& h &&& h) >>> 
  (h *** h *** h *** h *** h) >>>
  arr (const 3)

t = second (actor (const $ threadDelay 300000 >> print "A")) >>>
     first (actor (const $ threadDelay 300000 >> print "B"))

go = runKleisli (collapse t) ((), ())


data KleisliConcurrent m a b where
  KleisliSingle
    :: Kleisli m a b
    -> KleisliConcurrent m a b

  KleisliMany
    :: KleisliConcurrent m a b
    -> KleisliConcurrent m a' b'
    -> KleisliConcurrent m (a, a') (b, b')

  KleisliSingleToMany
    :: KleisliConcurrent m b c
    -> Kleisli m a b
    -> KleisliConcurrent m a c


collapse
  :: KleisliConcurrent IO a b
  -> Kleisli IO a b
  
collapse
  (KleisliSingle ab) = ab

collapse
  (KleisliMany ab ab') =
  Kleisli \(a,a') ->
  concurrently
  (runKleisli (collapse ab) a)
  (runKleisli (collapse ab') a')

collapse
  (KleisliSingleToMany bc ab) =
  collapse bc . ab


instance Arrow (KleisliConcurrent IO) where
  arr f = KleisliSingle $ arr f
  (***) = KleisliMany
  first f = f *** id
  second f = id *** f
  
  (&&&) bc bc' = KleisliSingleToMany
    (KleisliMany bc bc')
    (arr (\a -> (a,a)))
    
instance Category (KleisliConcurrent IO) where
  id = KleisliSingle id

  
  (.) (KleisliSingle bc) (KleisliSingle ab)
    = KleisliSingle $ bc . ab

  (.) (KleisliSingle bc) ab@(KleisliMany _ _) 
    = KleisliSingle (bc . collapse ab)

  (.) (KleisliSingle cd) (KleisliSingleToMany bc ab)
    = KleisliSingle (cd . collapse bc . ab)

      
  (.) (KleisliMany bc bc') (KleisliMany ab ab')
    = KleisliMany (bc . ab) (bc' . ab')

  (.) bc@(KleisliMany _ _) (KleisliSingle ab)
    = KleisliSingleToMany bc ab
    
  (.) cd@(KleisliMany _ _) (KleisliSingleToMany bc ab)
    = KleisliSingleToMany (cd . bc) ab


  (.) (KleisliSingleToMany de cd) (KleisliSingleToMany bc ab)
    = KleisliSingleToMany de (cd . collapse bc . ab)

  (.) (KleisliSingleToMany db bc) (KleisliSingle ab)
    = KleisliSingleToMany db (bc . ab)

  (.) (KleisliSingleToMany cd bc) ab@(KleisliMany _ _)
    = KleisliSingleToMany cd (bc . collapse ab)




-- newtype ActorUnit state a b = ActorUnit
--   { runActor :: Kleisli state a (Maybe b) }

-- instance Category (ActorUnit IO) where
--   id = ActorUnit $ Kleisli (pure . pure)
--   (ActorUnit (Kleisli bc)) . (ActorUnit (Kleisli ab))
--     = ActorUnit $ Kleisli $ \a -> do
--      mb <- ab a
--      case mb of
--        Just b -> bc b
--        Nothing -> pure Nothing

-- instance Arrow (ActorUnit IO) where
--   arr f = ActorUnit $ Kleisli $ \a -> pure $ pure $ f a
--   (***)
--     (ActorUnit (Kleisli f1))
--     (ActorUnit (Kleisli f2)) = ActorUnit $ Kleisli $ \(a, a') -> do
--     res <- concurrently (f1 a) (f2 a')
--     case res of
--       (Just b, Just b') -> pure $ pure (b,b')
--       _ -> pure $ Nothing




-- ** StateUnit'

-- data StateUnitList m a b where
--   StateUnitList :: MVar a -> ActionList m a (Maybe b) -> StateUnitList m a b

-- data ActionList m a c where
--   ActionCons :: Monad m => (a -> m b) -> ActionList m b c
--   ActionNil :: ActionList m a a

-- ** StateUnit''

-- data StateUnit'' m a b
--   = StateUnit''
--     { provider'' :: MVar a
--     , consumer_action_chain'' :: ActionList m a (Maybe b) }

-- since still have the individual actions in the ActionList, can apply an effect to each individual action
--   can do things like: giving each action a unique Reader value in which contains that specific action information about
--   its position in the state unit execution      

-- instance Arrow (StateUnit'' m) where


-- newtype ActorUnit state a b = ActorUnit
--   { runActor :: ActionUnit state a (Async (Maybe b)) }

-- instance Category (ActorUnit IO) where
--   id = ActorUnit $ ActionUnit (async . pure . pure)
--   (ActorUnit (ActionUnit bc)) . (ActorUnit (ActionUnit ab))
--     = ActorUnit $ ActionUnit $ \a -> do
--      promise_mb <- ab a
--      mb <- wait promise_mb
--      case mb of
--        Just b -> bc b
--        Nothing -> async $ pure Nothing

-- instance Arrow (ActorUnit IO) where
--   arr f = ActorUnit $ ActionUnit $ \a -> async $ pure $ pure $ f a 
--   (***)
--     (ActorUnit (ActionUnit f1))
--     (ActorUnit (ActionUnit f2)) = ActorUnit $ ActionUnit $ \(a, a') -> do
--     asynca <- f1 a
--     asynca'<- f2 a'
--     res <- waitBoth asynca asynca'
--     case res of
--       (Just b, Just b') -> async $ pure $ pure (b,b')
--       _ -> async $ pure $ Nothing
