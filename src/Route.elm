module Route exposing (Route(..), fromUrl, href, parser, routeToString)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)



{- If you want to add a route, add type this. -}


type Route
    = SampleView



{- If you want to add url parser, add a parser as below.
   Parser.map SampleView (Parser.s "elm-spa-starter" </> Parser.s "view")
-}


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        []


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)



{- If you want to add route to string function, add case as below.
   SampleView ->
       [ "view" ]
-}


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                SampleView ->
                    [ "view" ]
    in
    "/elm-my-spa/" ++ String.join "/" pieces
