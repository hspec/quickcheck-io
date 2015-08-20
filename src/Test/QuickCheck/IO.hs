{-# LANGUAGE CPP, TypeSynonymInstances, FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Test.QuickCheck.IO where

import qualified Control.Exception as E
import           Test.HUnit.Lang (Assertion, HUnitFailure(..))
import           Test.QuickCheck.Property

instance Testable Assertion where
  property = propertyIO
  exhaustive _ = True

propertyIO :: Assertion -> Property
#if MIN_VERSION_QuickCheck(2,7,0)
propertyIO action = ioProperty $ do
#else
propertyIO action = morallyDubiousIOProperty $ do
#endif
  (action >> return succeeded) `E.catch`
#if MIN_VERSION_HUnit(1,3,0)
    \(HUnitFailure _ err) ->
#else
    \(HUnitFailure err) ->
#endif
      return failed {reason = err}
