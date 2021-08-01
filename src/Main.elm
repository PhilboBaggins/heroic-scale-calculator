module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
--import Html exposing (Html, button, div, text)
--import Html.Events exposing (onClick)
import Html.Events exposing (onInput)

heroicScaleUpper = 50
heroicScaleLower = 64

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { realWorldMillimetres : Float }

init : Model
init =
  Model 0

type Msg
  = RealWorldMillimetres String
  | HeroicMillimetresLower String
  | HeroicMillimetresUpper String
  | RealWorldInches String
  | HeroicInchesLower String
  | HeroicInchesUpper String

update : Msg -> Model -> Model
update msg model =
  case msg of
    RealWorldMillimetres value ->
      { model | realWorldMillimetres = case (String.toFloat value) of
        Nothing -> 0
        Just v -> v }

    HeroicMillimetresLower value ->
      { model | realWorldMillimetres = case (String.toFloat value) of
        Nothing -> 0
        Just v -> v * 61 }

    HeroicMillimetresUpper value ->
      { model | realWorldMillimetres = case (String.toFloat value) of
        Nothing -> 0
        Just v -> v * heroicScaleUpper }

    RealWorldInches value ->
      { model | realWorldMillimetres = case (String.toFloat value) of
        Nothing -> 0
        Just v -> inchesTomm v }

    HeroicInchesLower value ->
      { model | realWorldMillimetres = case (String.toFloat value) of
        Nothing -> 0
        Just v -> inchesTomm (v * 61) }

    HeroicInchesUpper value ->
      { model | realWorldMillimetres = case (String.toFloat value) of
        Nothing -> 0
        Just v -> inchesTomm (v * heroicScaleUpper) }

view : Model -> Html Msg
view model =
  table []
        [ thead []
          [ tr []
            [ th []
              [ text "" ]
            , th []
              [ text "Real world" ]
            , th []
              [ text (String.concat ["Lower end of heroic scale (1/", (String.fromInt heroicScaleLower), ")"]) ]
            , th []
              [ text (String.concat ["Upper end of heroic scale (1/", (String.fromInt heroicScaleUpper), ")"]) ]
            , th []
              [ text "Heroic scale range" ]
            ]
          ]
        , tbody []
          [ tr []
              [ td [ style "font-weight" "bold" ]
                [ text "Millimetres:" ]
              , td []
                [ viewInput "number" "Real world (mm)" model.realWorldMillimetres RealWorldMillimetres ]
              , td []
                [ viewInput "number" "Heroic (lower) (mm)" (model.realWorldMillimetres / 61) HeroicMillimetresLower ]
              , td []
                [ viewInput "number" "Heroic (upper) (mm)" (model.realWorldMillimetres / heroicScaleUpper) HeroicMillimetresUpper ]
              , td []
                [ rangeDisplay (model.realWorldMillimetres / heroicScaleUpper) (model.realWorldMillimetres / 61) ]
              ]
          , tr []
              [ td [ style "font-weight" "bold" ]
                [ text "Inches:" ]
              , td []
                [ viewInput "number" "Real world (inches)" (mmToInches model.realWorldMillimetres) RealWorldInches ]
              , td []
                [ viewInput "number" "Heroic (lower) (inches)" (mmToInches (model.realWorldMillimetres / 61)) HeroicInchesLower ]
              , td []
                [ viewInput "number" "Heroic (upper) (inches)" (mmToInches (model.realWorldMillimetres / heroicScaleUpper)) HeroicInchesUpper ]
              , td []
                [ rangeDisplay (mmToInches (model.realWorldMillimetres / heroicScaleUpper)) (mmToInches (model.realWorldMillimetres / 61)) ]
              ]
            ]
         ]

mmToInches: Float -> Float
mmToInches mmVal = mmVal / 25.4

inchesTomm: Float -> Float
inchesTomm inchesVal = inchesVal * 25.4

viewInput : String -> String -> Float -> (String -> msg) -> Html msg
viewInput t p v toMsg = 
  input [ type_ t, placeholder p, value (String.fromFloat v), onInput toMsg ] []

rangeDisplay : Float -> Float -> Html msg
rangeDisplay v1 v2 = 
  p [] [ text (String.fromFloat (v1 - v2)) ]
