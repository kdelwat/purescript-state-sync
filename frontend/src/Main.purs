module Main where

import Prelude

import Effect (Effect)
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.Subscription as HS
import Halogen.VDom.Driver (runUI)
import Effect.Console (log)
import Lib (Msg(..), Model, init, update)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Core (stringify)
import Effect.Aff (launchAff, launchAff_)
import Affjax as AX
import Affjax.ResponseFormat as ResponseFormat
import Affjax.RequestBody as RequestBody
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))

foreign import alert :: String -> Effect Unit

main :: Effect Unit
main = void $ launchAff $ do
  res <- AX.get ResponseFormat.json "http://localhost:8888"
  case res of
    Left err -> liftEffect $ alert "Could not read model from server"
    Right parsed ->
      do
        liftEffect $ log ("body" <> stringify (parsed.body))
        case decodeJson parsed.body of
          Left err ->
            liftEffect $ alert "Could not read model from server"
          Right model ->
            liftEffect $ HA.runHalogenAff do
              body <- HA.awaitBody
              io <- runUI (component model) unit body

              liftEffect $ HS.subscribe io.messages handleMsg

handleMsg :: Msg -> Effect Unit
handleMsg msg = do
  let encoded = encodeJson msg
  log (stringify encoded)
  launchAff_ $ AX.post ResponseFormat.json "http://localhost:8888" (Just (RequestBody.json encoded))

component initS =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  initialState _ = initS

  render state =
    HH.div_
      [ HH.button [ HE.onClick \_ -> Decrement ] [ HH.text "-" ]
      , HH.div_ [ HH.text $ show state ]
      , HH.button [ HE.onClick \_ -> Increment ] [ HH.text "+" ]
      ]

  handleAction action = do
    H.modify_ \state -> update action state
    H.raise action
