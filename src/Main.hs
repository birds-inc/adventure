import Control.Exception
import System.Directory

import Creature
import Menu
import World

defaultDatafile :: String
defaultDatafile = "data.txt"

main :: IO ()
main = startWorld defaultDatafile
    >>= openingGreeting
    >>= runMenu mainMenu
    >>= exitAdventure

-- actions
startWorld :: String -> IO World
startWorld filename = do
    w <- loadWorld filename
    case w of
        Just world -> return world
        Nothing -> return $ newWorld defaultDatafile

openingGreeting :: World -> IO World
openingGreeting world =
    case player world of
        Just p -> do
            putStrLn $ "Welcome back to Adventure, " ++ name p
            return world
        Nothing -> do
            putStrLn "Welcome to Adventure!"
            -- create player and save
            p <- getCreature
            saveWorld $ setPlayer p world

exitAdventure :: World -> IO ()
exitAdventure world = do
    saveWorld world
    putStrLn "Until next time, adventurer."

-- main menu
greet :: World -> IO World
greet world = do 
    case player world of
        Just p -> putStrLn $ "Hello there, " ++ name p
        Nothing -> putStrLn "Hello, stranger."
    return world

setPlayerName :: World -> IO World
setPlayerName world = do
    p <- getCreature
    return $ setPlayer p world

resetData :: World -> IO World
resetData world = do
    let df = datafile world
    removeFile df
    return $ newWorld df

mainMenu :: Menu.Menu World
mainMenu = getMenu
    [ MenuItem "Greet me" greet
    , MenuItem "Set player name" setPlayerName
    , MenuItem "Reset all user data" resetData
    , Close "Exit"
    ]
