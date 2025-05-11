import Control.Concurrent (threadDelay)

data DrinkType = Water | Juice | Milk | Tea | Coffee | Soda | Smoothie | HotChocolate
  deriving (Show, Eq)

data Glass = Glass
  { drink     :: DrinkType
  , volume    :: Float
  , maxVolume :: Float
  } deriving (Show)

data User = User
  { isThirsty :: Bool
  } deriving (Show)

data Intern = Intern

isEmpty :: Glass -> Bool
isEmpty g = volume g <= 0

drinkFromGlass :: User -> Glass -> (User, Glass)
drinkFromGlass user glass
  | volume glass >= 10 = (user { isThirsty = False }, glass { volume = volume glass - 10 })
  | otherwise          = (user { isThirsty = False }, glass { volume = 0 })

fillGlass :: Intern -> Glass -> Glass
fillGlass _ glass = glass { volume = maxVolume glass }

work :: User -> IO User
work _ = do
  threadDelay (1 * 1000000)
  return User { isThirsty = True }

simulateDay :: Float -> User -> Glass -> IO ()
simulateDay time user glass
  | time >= 8 = return ()
  | otherwise = do
      let (user', glass') = if not (isEmpty glass) && isThirsty user
                            then drinkFromGlass user glass
                            else if isEmpty glass && isThirsty user
                              then drinkFromGlass user (fillGlass Intern glass)
                              else (user, glass)
      userAfterWork <- work user'
      simulateDay (time + 1) userAfterWork glass'

main :: IO ()
main = do
  let initialGlass = Glass { drink = Water, volume = 0, maxVolume = 100 }
  let initialUser = User { isThirsty = True }
  simulateDay 0 initialUser initialGlass
