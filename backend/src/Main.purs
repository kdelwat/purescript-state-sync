module Main where

import Data.Bifunctor
import Prelude

import Control.Monad.Except (ExceptT, runExcept)
import Data.Argonaut.Core (stringify)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Ref (Ref, modify, read, new)
import Foreign (unsafeFromForeign)
import Lib (Model, update, init, Msg(..))
import Node.Express.App (App, get, http, listenHttp, post, setProp, use, useExternal, useOnError)
import Node.Express.Handler (Handler, nextThrow, next)
import Node.Express.Request (getBody', getOriginalUrl, getQueryParam, getRouteParam, getUserData, setUserData)
import Node.Express.Response (sendJson, setResponseHeader, setStatus)
import Node.Express.Types (Middleware, Method(..))
import Node.HTTP (Server)

type AppState = Ref Model

foreign import cors :: Middleware
foreign import jsonBodyParser :: Middleware

modelHandler :: AppState -> Handler
modelHandler state = do
  model <- liftEffect $ read state
  liftEffect $ log $ "model: " <> show model
  setResponseHeader "Access-Control-Allow-Origin" "*"
  sendJson (encodeJson model)

msgHandler :: AppState -> Handler
msgHandler state = do
  body <- getBody'
  liftEffect $ log $ stringify (unsafeFromForeign body)
  case decodeJson (unsafeFromForeign body) of
    Left err -> do
      setStatus 400
      setResponseHeader "Access-Control-Allow-Origin" "*"
      sendJson { error: "Could not parse Msg: " <> show err }
    Right msg -> do
      liftEffect $ log $ "msg: " <> show msg
      model' <- liftEffect $ modify (update msg) state
      liftEffect $ log $ "model': " <> show model'
      setResponseHeader "Access-Control-Allow-Origin" "*"
      setStatus 200
      sendJson { status: "OK" }

app :: AppState -> App
app state = do
  useExternal cors
  useExternal jsonBodyParser
  get "/" (modelHandler state)
  post "/" (msgHandler state)

main :: Effect Server
main = do
  state <- new (init)
  listenHttp (app state) 8888 \_ ->
    log $ "Listening on " <> show 8888
