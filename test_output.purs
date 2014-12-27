module Main (main) where

import Data.Function

import qualified Thermite as T
import qualified Thermite.Html as T
import qualified Thermite.Html.Elements as T
import qualified Thermite.Html.Attributes as A
import qualified Thermite.Events as T

data Action = TextChanged String | ClearText

data State = State 
  { name :: String }

data Props = Props 
  { greeting :: String }

foreign import unsafeStringValue
  "function unsafeStringValue(e) {\
  \  return e.target.value;\
  \}" :: T.FormEvent -> String

initialState :: State
initialState = State { name: "" }

render :: T.Render State Props Action
render ctx (State s) (Props p) = T.div' $ welcome : response s.name
  where
    welcome :: T.Html _
    welcome = T.div' 
      [ flip T.input [] 
        [ A.value s.name
        , A.placeholder "What is your name?"
        , T.onChange ctx (TextChanged <<< unsafeStringValue) ]
      , T.button [ T.onClick ctx (\_ -> TextChanged "") ] [ T.text "Clear" ] ]

    response :: String -> [T.Html _]
    response "" = []
    response s = 
      [ T.div' 
        [ T.text p.greeting
        , T.text s ] ]

performAction :: T.PerformAction State Props Action _
performAction _ _ (TextChanged s) k = k (State { name: s })

spec :: T.Spec _ State Props Action
spec = T.Spec 
  { initialState: initialState
  , performAction: performAction
  , render: render }

combo = run 
  [ quux [ (foo { x: 1, y : 2 }), (bar { x: 1, y: 1 }) ]
    { a : 123
    , b : 45678 }
  , bazz { huh: "this stuff works!" } ]

main = do
  let component = T.createClass spec
  T.render component (Props { greeting: "Hello, " })