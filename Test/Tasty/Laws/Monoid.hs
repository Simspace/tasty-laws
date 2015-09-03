{-# LANGUAGE CPP #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Test.Tasty.Laws.Monoid where

#if !MIN_VERSION_base(4,8,0)
import Data.Monoid (Monoid)
#endif
import Data.Proxy (Proxy)
import Test.SmallCheck.Series (Series, Serial(series))
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.SmallCheck (testProperty)

import qualified Test.SmallCheck.Laws.Monoid as Monoid

-- | @tasty@ 'TestTree' for 'Applicative' laws. You need to provide the type
--   wrapped in a `Proxy` and make sure 'a' is an instance of 'Serial'.
testMonoid :: forall a . (Show a, Eq a, Monoid a, Serial IO a) => Proxy a -> TestTree
testMonoid _ = testGroup "Monoid laws"
  [ testProperty "mempty <> x ≡ x" $ Monoid.leftIdentity (series :: Series IO a)
  , testProperty "x <> mempty ≡ x" $ Monoid.rightIdentity (series :: Series IO a)
  , testProperty "x <> (y <> z) ≡ (x <> y) <> z"
  $ Monoid.associativity (series :: Series IO a) series series
  , testProperty "mconcat ≡ foldr mappend mempty"
  $ Monoid.mconcat (series :: Series IO a)
  ]
