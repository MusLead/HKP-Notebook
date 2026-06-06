# HKP-Notebook

This repository contains my Haskell learning notes and small practice files.

## Documentation overview

- **`MonadDemo.hs`**  
  Main Notes – A step-by-step Monad walkthrough using `Maybe`:
  - Monad idea: wrap a value together with a context (here: possible failure).
  - `Nothing` means computation failed, `Just x` means success with value `x`.
  - Shows the same evaluator in four styles: nested `case`, explicit bind, `>>=`, and `do` notation.
  - Includes safe division examples so you can see how failure is propagated automatically.

- **`haskell_summary.md`**  
  The summary of core Haskell topics: list functions, operators, folds, `map`/`mapM`, IO basics, and type classes.

- **`IO_Summary.md`**  
  Focused explanation of `IO ()` vs `IO Char` using the example functions `ff` and `fff`, with behavior examples and intuition about effects vs returned values.

## Related practice files

- **`MonadVorlesung.hs`**
- **`MyNotes.hs`**
- **`hkp.tsv`**

These files are companion material to the written summaries.