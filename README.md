# quickcheck-io: Use HUnit assertions as QuickCheck properties

This package provides an orphan instance that allows you to use HUnit
assertions as QuickCheck properties.

Why would you want to do this?

### Convenient testing of IO actions

Example: Setting an environment variable with `setEnv` and then getting the
value back with `getEnv` should work for _arbitrary_ key–value pairs.  Sounds
like a job for QuickCheck, huh?

```haskell
import Test.QuickCheck
import Test.QuickCheck.IO ()
import Test.Hspec.Expectations (shouldReturn)

import System.SetEnv (setEnv)
import System.Environment (getEnv)

prop_setEnv k v = validKey k && validValue v ==> do
  setEnv k v
  getEnv k `shouldReturn` v

validKey   k = (not . null) k && '\NUL' `notElem` k && '=' `notElem` k
validValue v = (not . null) v && '\NUL' `notElem` v
```

    ghci>>> quickCheck prop_setEnv
    +++ OK, passed 100 tests.

### Better error messages for failing QuickCheck properties

You can e.g. use HUnit's `@?=`

    ghci> import Test.QuickCheck
    ghci> import Test.QuickCheck.IO
    ghci> import Test.HUnit
    ghci> quickCheck $ \x -> x + 23 @?= 23
    *** Failed! (after 3 tests and 2 shrinks):                             
    expected: 23
     but got: 24
    1

or Hspec's `shouldBe`

    ghci> import Test.QuickCheck
    ghci> import Test.QuickCheck.IO
    ghci> import Test.Hspec.Expectations
    ghci> quickCheck $ \x -> x + 23 `shouldBe` 23
    *** Failed! (after 3 tests and 2 shrinks):                             
    expected: 23
     but got: 24
    1
