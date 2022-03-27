{ name = "backend"
, dependencies =
  [ "argonaut-codecs"
  , "argonaut-core"
  , "bifunctors"
  , "console"
  , "effect"
  , "either"
  , "express"
  , "foreign"
  , "lib"
  , "node-http"
  , "prelude"
  , "refs"
  , "transformers"
  ]
, sources = [ "src/**/*.purs" ]
, packages = ../packages.dhall
}
