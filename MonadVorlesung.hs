-- data a = constructor [werte]
data Term = Con Integer | Ops Term Op Term deriving (Eq,Show)
data Op = Add | Sub | Mul | Div deriving (Eq,Show)

sys Add = (+)
sys Sub = (-)
sys Mul = (*)
sys Div = div

eval :: (Monad m, MonadFail m) => Term -> m Integer
eval (Con n) = return n
eval (Ops t1 op t2) = do
    v1 <- eval t1
    v2 <- eval t2
    if (v2 == 0 && op == Div)
    then fail "Div by zero"
    else return (sys op v1 v2)

-- eval without Term data type, just using the applyOp function.
applyOp :: (Monad m, MonadFail m) => Op -> m Integer -> m Integer -> m Integer
applyOp op ma mb = do
  a <- ma
  b <- mb
  if op == Div && b == 0
    then fail "Div by zero"
    else return (sys op a b)

-- ghci> applyOp Div (applyOp Div (Just 8) (Just 2)) (Just 2)

-- applyOp Div (applyOp Div (Right 8) (Right 2)) (Right 2) -- this will not work because Right from Either is not a MonadFail. We need to use Either String Integer instead.
-- Below is a more robust implementation of applyOp that works for Either String Integer. 
-- We will use the Either monad to handle errors instead of Maybe, 
-- so we can provide more informative error messages.
applyOpEither :: Op -> Either String Integer -> Either String Integer -> Either String Integer
applyOpEither op ea eb = do
  a <- ea
  b <- eb
  if op == Div && b == 0
    then Left "Div by zero"
    else Right (sys op a b)

-- ghci> applyOpEither Div (applyOpEither Div (Right 8) (Right 2)) (Right 2)

applyOpOM :: Op -> Integer -> Integer -> Integer
applyOpOM op ea eb = do
  let a = ea
  let b = eb
  if op == Div && b == 0
    then -1
    else sys op a b


