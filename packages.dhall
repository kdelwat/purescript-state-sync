let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.1-20210419/packages.dhall sha256:d9a082ffb5c0fabf689574f0680e901ca6f924e01acdbece5eeedd951731375a

let overrides =
  { lib = ./lib/spago.dhall as Location
  , frontend = ./frontend/spago.dhall as Location
  , backend = ./backend/spago.dhall as Location
  }

in  upstream // overrides
