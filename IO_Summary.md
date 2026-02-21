
## ff vs fff

```hs
ff  :: IO ()
ff = do 
    x <- getChar
    putChar x

fff :: IO Char
fff = do 
    x <- getChar
    return x
```

Let’s inspect their types first (this reveals everything):

```haskell
ff  :: IO ()
fff :: IO Char
```

---

## `ff`

```haskell
ff = do 
    x <- getChar
    putChar x
```

### Meaning

1. Read a character from input
2. Immediately print it to the screen

### Result value

`putChar :: Char -> IO ()`

So the final result is:

```
IO ()
```

The program performs an effect, but **returns no useful value** — only “side effect happened”.

Think:

> echo the character

---

## `fff`

```haskell
fff = do 
    x <- getChar
    return x
```

### Meaning

1. Read a character
2. Produce it as the result of the IO action

No printing happens.

### Result value

`return x :: IO Char`

So this action **produces data**, not an effect.

Think:

> fetch the character for later use

---

## Concrete behaviour

If user types `a`

### Running `ff`

```
input: a
output: a
result value: ()
```

### Running `fff`

```
input: a
output: (nothing printed)
result value inside IO: 'a'
```

(GHCi shows it because GHCi prints returned values automatically)

---

## Core conceptual difference

| Function | Purpose           | Returns | Side effect |
| -------- | ----------------- | ------- | ----------- |
| `ff`     | perform an action | `()`    | prints      |
| `fff`    | produce a value   | `Char`  | no printing |

---

## Deep intuition

`IO` does two independent things:

1. **effects** (printing, reading, files)
2. **producing values**

`putChar` → effect
`return` → produces a value without effect

So:

```haskell
putChar x
```

says *do something*

while

```haskell
return x
```

says *the computation’s result is x*

---

### Short mental model

`return` does **not send output to the user**
it sends output to the *next computation*
