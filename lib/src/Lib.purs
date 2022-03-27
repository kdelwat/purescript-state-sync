module Lib where

import Prelude

import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Argonaut.Decode.Generic (genericDecodeJson)
import Data.Argonaut.Encode.Class (class EncodeJson)
import Data.Argonaut.Encode.Generic (genericEncodeJson)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data Msg = Increment | Decrement

derive instance genericMsg :: Generic Msg _

instance showMsg :: Show Msg where
  show = genericShow

instance encodeJsonMsg :: EncodeJson Msg where
  encodeJson = genericEncodeJson

instance decodeJsonMsg :: DecodeJson Msg where
  decodeJson = genericDecodeJson

type Model = Int

init :: Model
init = 0

update :: Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model + 1
    Decrement -> model - 1
