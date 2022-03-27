{ name = "frontend"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut-codecs"
  , "argonaut-core"
  , "argonaut-generic"
  , "console"
  , "effect"
  , "either"
  , "halogen"
  , "halogen-subscriptions"
  , "lib"
  , "prelude"
  , "simple-json"
  ]
, sources = [ "src/**/*.purs" ]
, packages = ../packages.dhall
}
