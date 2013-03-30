{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
module Test.QuickCheck.IO where

import qualified Control.Exception as E
import           Test.HUnit.Lang (Assertion, HUnitFailure(..))
import           Test.QuickCheck.Property

instance Testable Assertion where
  property = propertyIO
  exhaustive _ = True

propertyIO :: Assertion -> Property
propertyIO action = morallyDubiousIOProperty $ do
  (action >> return succeeded) `E.catch` \(HUnitFailure err) -> return failed {reason = err}
