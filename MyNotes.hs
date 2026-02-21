list_sum :: Num a => [(a, a)] -> [a]
list_sum [] = []
list_sum ((x,y):xs) = (x+y) : list_sum xs


fg = do 
    x <- getChar 
    return (x == 'a')

ff = do 
    x <- getChar
    putChar x

fff = do 
    x <- getChar
    return x

main = do
  x <- return 42
  print x

data Box a = Box a
  deriving (Eq, Show)