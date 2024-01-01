module Main where

import Prelude (IO)
import Prelude qualified

import Control.Category


-- https://www.reddit.com/r/haskell/comments/eoo16m/base_category_polymorphic_functor_and_functorof/
-- https://www.reddit.com/r/haskell/comments/pqhivm/type_class_backend_how_to_evolve_with_class/
-- https://discourse.haskell.org/t/request-for-comment-functor-monad-package/8387
-- https://elvishjerricco.github.io/2017/03/10/profunctors-arrows-and-static-analysis.html
-- https://arxiv.org/abs/1406.4823
-- https://rpeszek.github.io/posts/2021-06-28-polysemy-arrows.html
-- https://richarde.dev/papers/2020/workflows/workflows.pdf
-- https://github.com/tweag/kernmantle
-- https://guide.aelve.com/haskell/alternative-preludes-zr69k1hc

-- https://www.tweag.io/blog/2020-07-13-qualified-do-announcement/

-- import Control.Arrow qualified as Arrow
-- import Control.Monad qualified as Monad
-- import Control.Applicative qualified as Applicative

import Data.Profunctor qualified as Profunctor

-- import Data.Kind

main :: IO ()
main = Prelude.undefined



class (Category k) => Functor k f where
  map :: (a `k` b) -> (f a `k` f b)

class (Category k, Functor k f) => Applicative k f where
  pure  :: (a `k` f a)
  (<*>) :: f (a `k` b) -> (f a `k` f b)

class (Category k, Applicative k f) => Monad k f where
  (>>=) :: f a -> (a `k` f b) -> f b
  -- (>=>) :: (a `k` f b) -> (b `k` f c) -> (a `k` f c)


data Proxy k

bind :: Monad k f => f a -> (a `k` f b) -> f b
bind = (>>=)

(>>)
  :: forall k f a b .
  ( Monad k f
  , PreArrow k (->)
  , K k
  ) => f a -> f b -> f b
(>>) ma mb = (bind @k @f) ma (const mb)
  where
    const :: x -> (y `k` x)
    const = arr k

hi :: forall k f . (PreArrow k (->), Monad k f) => f ()
hi = do
  arr @k pure ()


return :: (Monad k f) => (a `k` f a)
return = pure

class Profunctor k f where
  dimap
    :: (a' `k` a )
    -> (b  `k` b')
    -> ((a `f` b) `k` (a' `f` b'))

class ( Category k, Category f ) => PreArrow k f where
  arr :: (a `k` b) -> (a `f` b)

class K k where
  k :: b `k` (a `k` b)


  -- dimap l r = lmap l . rmap r

-- class (Category k, Category l) => Arrow k l where
--   arr :: (a `k` b) -> a `l` b
--   first :: (a `k` b) -> a `l` b

instance Prelude.Functor f => Functor (->) f where
  map = Prelude.fmap

instance Prelude.Applicative f => Applicative (->) f where
  pure = Prelude.pure
  (<*>) = (Prelude.<*>)

instance Prelude.Monad f => Monad (->) f where
  (>>=) = (Prelude.>>=)

instance Profunctor.Profunctor f => Profunctor (->) f where
  dimap = Profunctor.dimap

-- instance Arrow.Arrow l => Arrow (->) l where
--   arr = Arrow.arr
--   first = 


-- need some sort of parametrised arrow

-- class ArrowK k 

-- a :: Arrow
-- a = _


-- class CategoryK k cat where
--   id  :: cat k a a
--   (.) :: cat k b c `k` (cat k a b `k` cat k a c)

-- actually can just use the default Category

-- data a :-> b where
--   K :: (Num a, Num b) => (a -> b) -> (a :-> b)


-- class ArrowK k a where
--   arrP :: (b `k` c) -> a b c
