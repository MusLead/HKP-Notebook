-- What is Monad? 
-- Computherphile (21:50 Minutes):  https://youtu.be/t1e8gqXLbsU?si=D_km5tI2EhrFlhIB
-- A Byte of Code (2:30 Minutes): https://youtu.be/VgA4wCaxp-Q?si=HK1InfYfWahIJFBe

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

-- explicit bind
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
  bindMaybe (evalBindExplicit x) $ \n ->
    bindMaybe (evalBindExplicit y) $ \m ->
      safediv n m

-- >>= version
evalBind :: Expr -> Maybe Int
evalBind (Val n) = return n
evalBind (Div x y) =
  evalBind x >>= (\n ->
    evalBind y >>= (\m ->
      safediv n m))

-- do notation version
eval :: Expr -> Maybe Int
eval (Val n) = return n
eval (Div x y) = do
  n <- eval x
  m <- eval y
  safediv n m