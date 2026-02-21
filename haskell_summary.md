TODO: add somenote about such operations (+2) and an exception to (-2) that is not operation, instead it should be writen (substract 2)

# LIST FUNCTIONS

---

## `filter :: (a -> Bool) -> [a] -> [a]`

**Inputs**

* `p :: a -> Bool` → a test function (returns True or False for one element)
* `xs :: [a]` → a list of elements

**Output**

* A list containing only elements where `p element == True`

**Expectation**

* Same order
* Possibly shorter list
* Never changes element values

**Example**

```
filter even [1,2,3,4] = [2,4]
```

---

## `take :: Int -> [a] -> [a]`

**Inputs**

* `n :: Int` → how many elements to keep
* `xs :: [a]` → list

**Output**

* First `n` elements

**Expectation**

* If `n > length xs` → returns whole list
* If `n <= 0` → empty list

**Example**

```
take 3 [10,20,30,40] = [10,20,30]
```

---

## `(++) :: [a] -> [a] -> [a]`

**Inputs**

* `xs :: [a]`
* `ys :: [a]`

**Output**

* One combined list

**Expectation**

* Order preserved: xs first, ys after

**Example**

```
[1,2] ++ [3,4] = [1,2,3,4]
```

---

## `(:) :: a -> [a] -> [a]`

**Inputs**

* `x :: a` → one element
* `xs :: [a]` → list

**Output**

* New list with x at front

**Expectation**

* Adds element to beginning
* Fast operation

**Example**

```
1 : [2,3] = [1,2,3]
```

---

## `(!!) :: [a] -> Int -> a`

**Inputs**

* `xs :: [a]`
* `i :: Int` index (starting at 0)

**Output**

* Element at position i

**Expectation**

* Error if index too large or negative

**Example**

```
["a","b","c"] !! 1 = "b"
```

---

## `head :: [a] -> a`

**Inputs**

* Non-empty list

**Output**

* First element

**Expectation**

* Crash on empty list

```
head [5,6,7] = 5
```

---

## `tail :: [a] -> [a]`

**Inputs**

* Non-empty list

**Output**

* Everything except first element

```
tail [5,6,7] = [6,7]
```

---

## `last :: [a] -> a`

**Inputs**

* Non-empty list

**Output**

* Final element

```
last [5,6,7] = 7
```

---

## `init :: [a] -> [a]`

**Inputs**

* Non-empty list

**Output**

* Everything except last element

```
init [5,6,7] = [5,6]
```

---

## `drop :: Int -> [a] -> [a]`

**Inputs**

* `n` how many to remove from the left
* list

**Output**

* Remaining list

**Expectation**

* If n too large → empty list

```
drop 2 [1,2,3,4] = [3,4]
```

---

## `reverse :: [a] -> [a]`

**Output**

* Same elements reversed

```
reverse [1,2,3] = [3,2,1]
```

---

## `zip :: [a] -> [b] -> [(a,b)]`

**Inputs**

* two lists

**Output**

* paired elements

**Expectation**

* Stops at shortest list

```
zip [1,2,3] ['a','b'] = [(1,'a'),(2,'b')]
```

---

## `unzip :: [(a,b)] -> ([a],[b])`

**Inputs**

* One List with Tupples of two elements

**Output**

* separates pairs

```
unzip [(1,'a'),(2,'b')] = ([1,2],['a','b'])
```

---

# FUNCTION OPERATORS

---

## `($) :: (a -> b) -> a -> b`

### Inputs

* a function `f :: a -> b`
* a value `x :: a`

### Output

* the result `f x :: b`

### Meaning

`$` is **just function application**, but with *very low precedence*.
It lets you remove parentheses by forcing everything on its right to be taken as one argument.

```hs
f $ x    =    f x
```

---

## Expectation

Equivalent to parentheses — but only for the **final argument**.

---

### Example 1

```hs
even $ sum $ [1,2,3]
= even (sum [1,2,3])
= even 6
= True
```

---

### Example 2

```hs
even $ sum $ filter odd $ [1,2,3]
= even (sum (filter odd [1,2,3]))
= even 4
= True
```

---

## Important note

`$` does **not** change evaluation or number of arguments.
It only changes grouping (parsing).

So:

```hs
f (g (h x))  ==  f $ g $ h x
```

but not every rearrangement works — only the *rightmost expression* becomes the argument.

---

### Short mental model

> `$` = “take everything to my right as one argument”

---

## `(.) :: (b -> c) -> (a -> b) -> a -> c`

**Inputs**

* `f :: b -> c`  (first function)
* `g :: a -> b`  (second function)
* `x :: a`       (the value you finally apply to)

**Output**

* `f (g x) :: c`

**What to expect**

* `g` runs first on `x`
* its result is fed into `f`

**Example**

```hs
(length . reverse) [1,2,3] = 3
```

```haskell
f = length   :: [t] -> Int
g = reverse  :: [t] -> [t]
x = [1,2,3]  :: [Int]

(f . g) x 
= (length . reverse) [1,2,3]
= length (reverse [1,2,3]) = 3
```

---

## `flip :: (a -> b -> c) -> b -> a -> c`

### Inputs

* a function `f :: a -> b -> c` (a function that takes two arguments)
* a value `y :: b` (the second argument of the original function)
* a value `x :: a` (the first argument of the original function)

### Output

* the result `f x y :: c`, but with the argument order swapped

### Meaning

`flip` reverses the order of the first two parameters of a function.

```hs
flip f y x = f x y
```

### Example

```hs
flip div 2 10
= div 10 2
= 5
```


---

# MAP AND FOLD

---

## `map :: (a -> b) -> [a] -> [b]`

**Inputs**

* transform function
* list

**Output**

* new list with transformed values

```
map (*2) [1,2,3] = [2,4,6]
```

---

## `foldr :: (a -> b -> b) -> b -> [a] -> b`

**Inputs**

* combine function
* start value
* list

**Expectation**

* Processes from right

```
foldr (-) 0 [1,2,3] = (1 - (2 - (3 - 0))) = 2
```

---

## `foldl :: (b -> a -> b) -> b -> [a] -> b`

**Expectation**

* Processes from left

```
foldl (-) 0 [1,2,3] = (((0 - 1) - 2) - 3) = -6
```

---

## `foldr1 :: (a -> a -> a) -> [a] -> a`

Like foldr but uses last element as start.

```
foldr1 (-) [1,2,3] = (1 - (2 - 3)) = 2
```

---

## `foldl1 :: (a -> a -> a) -> [a] -> a`

Like foldl but uses first element as start.

```
foldl1 max [3,7,2] = (max (max 3 7) 2) = max 7 2 = 7
```

---

## IO functions with examples

### `putChar :: Char -> IO ()`

**Input**

* `c :: Char`

**Output**

* `IO ()` (it performs printing; result value is “nothing useful”)

**Example**

```haskell
main = putChar 'A'
-- prints: A
```

---

### `getChar :: IO Char`

**Input**

* no normal input (reads from keyboard)
* From the IO Action it will give back a Char value

**Output**

* `Char` wrapped in IO

**Example**

```haskell
main = do
  c <- getChar
  putChar c
```

What you expect:

* you type one character (e.g. `x`)
* it prints that character (`x`)

---

### `getLine :: IO String`

**Input**

* no normal input (reads from keyboard)
* From the IO Action it will give back a String value

**Output**

* one line as a `String`

**Example**

```haskell
main = do
  s <- getLine
  putStrLn ("You typed: " ++ s ++ "\n")
```

---

### `putStrLn :: String -> IO ()`

**Input**

* `s :: String`

**Output**

* prints the string + newline

**Example**

```haskell
main = putStrLn "Hello"
-- prints:
-- Hello
```

---

### `writeFile :: FilePath -> String -> IO ()`

**Inputs**

* `path :: FilePath` (example `"out.txt"`)
* `content :: String`

**Output**

* writes file (overwrites)

**Example**

```haskell
main = writeFile "out.txt" "Hi\nLine2\n"
```

---

### `readFile :: FilePath -> IO String`

**Input**

* `path :: FilePath`

**Output**

* file content as `String` in IO (in this context, we get String from IO)

**Example**

```haskell
main = do
  txt <- readFile "out.txt"
  putStrLn txt
```

---

### `return :: a -> m a`

**Input**

* `x :: a` (pure value)

**Output**

* same value but inside a monad

**Example**

```haskell
main = do
  x <- return 42
  print x
```

Expectation:

* prints `42`
* note: `return` does **not** print; it only wraps into monad IO.

---

# TYPE CLASSES

---

## Definition

A **type class** = requirement a type must satisfy to be used by a function.

---

## Short meanings

* **Eq** → supports `==`
* **Show** → supports `show`
* **Ord** → supports comparison `<` ,`<=` ,`>`. Eq required to be written!
* **Monad** → supports sequencing `(>>=)` , `(>>)`

---

## Usage

### A) Function with a type class constraint

```haskell
same :: Eq a => a -> a -> Bool
same x y = x == y
```

**Inputs**

* `x :: a`
* `y :: a`
* plus the *requirement*: `a` must be an instance of `Eq`

**Output**

* `Bool`

**What to expect**

* Works for types like `Int`, `Char`, `String`, lists, tuples… as long as they have `Eq`.

Examples:

```haskell
same 3 3         = True
same "hi" "ho"   = False
same [1,2] [1,2] = True
```

If a type has no `Eq` instance, this won’t compile.

---

### B) Datatype deriving a type class (how it becomes usable)

```haskell
data Box a = Box a
  deriving (Eq, Show)
```

**What you gain immediately**

* Because of `deriving Eq` you can do:

  * `(==) :: Box a -> Box a -> Bool`  (but only if `a` is also `Eq`)
* Because of `deriving Show` you can do:

  * `show :: Box a -> String` (but only if `a` is also `Show`)

Examples:

```haskell
Box 5 == Box 5        -- True
show (Box 5)          -- "Box 5"
Box "a" == Box "b"    -- False
```

Important “expectation”:

* The derived instance compares/prints by looking at the constructor and its fields.

---

### C) `Ord` deriving (and what ordering means)

```haskell
data Pair a = Pair a a
  deriving (Eq, Show, Ord)
```

**What to expect**

* Ordering is **lexicographic** (like dictionary order):

  * compare first field; if equal, compare second field

Example:

```haskell
Pair 1 9 < Pair 2 0    -- True   (because 1 < 2)
Pair 1 9 < Pair 1 10   -- True   (first equal, compare second)
```

---

### D) Monad constraint (same pattern as Eq/Ord)

Example:

```haskell
twice :: Monad m => m a -> m (a, a)
twice mx = do
  x <- mx
  return (x, x)
```

**Inputs**

* `mx :: m a` where `m` must be a Monad

**Output**

* `m (a, a)`

**What to expect**

* Works for `Maybe`, `[]` (list), `IO`, etc.

Examples:

```haskell
twice (Just 7)   = Just (7,7)
twice [1,2]      = [(1,1),(2,2)]
-- in IO: reads once and duplicates the value
```

