-- What is Monad? 
-- Computherphile (21:50 Minutes):  https://youtu.be/t1e8gqXLbsU?si=D_km5tI2EhrFlhIB
-- A Byte of Code (2:30 Minutes): https://youtu.be/VgA4wCaxp-Q?si=HK1InfYfWahIJFBe

-- Below is an example of a simple expression language with division.
-- We want to evaluate expressions, but division by zero is a problem. This creates a side effect (failure) that we need to handle. 
-- We will use the Maybe monad to handle this possibility of failure gracefully.

-- In GHCI try (Do not forget the brackets!):
-- eval (Val 2)
-- eval (Div (Val 10) (Val 2))
-- eval (Div (Val 10) (Val 0))              -- Nothing
-- eval (Div (Val 10) (Div (Val 3) (Val 0))) -- Nothing

data Expr
  = Val Int
  | Div Expr Expr
  deriving (Show, Eq)

safediv :: Int -> Int -> Maybe Int
safediv n m =
  if m == 0
    then Nothing
    else Just (n `div` m)

-- nested case version
evalCase :: Expr -> Maybe Int
evalCase (Val n) = Just n
evalCase (Div x y) =
  case evalCase x of
    Nothing -> Nothing
    Just n ->
      case evalCase y of
        Nothing -> Nothing
        Just m  -> safediv n m

-- explicit bind. This is what >>= does under the hood. 
-- We will see how to use >>= to simplify this code.
-- since (>>=) :: m a -> (a -> m b) -> m b
bindMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
bindMaybe m f =
  case m of
    Nothing -> Nothing
    Just x  -> f x

-- explicit bind version
evalBindExplicit :: Expr -> Maybe Int
evalBindExplicit (Val n) = Just n
evalBindExplicit (Div x y) =
  bindMaybe (evalBindExplicit x) (\n ->
    bindMaybe (evalBindExplicit y) (\m ->
      safediv n m))

-- >>= version
evalBind :: Expr -> Maybe Int
evalBind (Val n) = return n
evalBind (Div x y) =
  evalBind x >>= (\n ->
    evalBind y >>= (\m ->
      safediv n m))

-- do notation version
-- do-notation is basically a safe let for computations that may fail. 
eval :: Expr -> Maybe Int
-- return is a way to lift a pure value into the MONAD. 
-- In this case, it takes an Int and returns a Maybe Int (specifically Just n).
eval (Val n) = return n -- return :: a -> m a, automaticale ly wraps the pure value n into the Maybe monad.
eval (Div x y) = do
  n <- eval x 
  m <- eval y
  safediv n m

-- Comparison without do notation (evalPure)
evalPure :: Expr -> Int
evalPure (Val n) = n -- without return, we just return the pure value directly.
evalPure (Div x y) =
  let n = evalPure x
      m = evalPure y
  in if m == 0
        then error "division by zero"
        else n `div` m