module NoPrimitiveTypeAlias exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Declaration as Declaration exposing (Declaration)
import Elm.Syntax.Node as Node exposing (Node)
import Elm.Syntax.TypeAnnotation as TypeAnnotation
import Review.Rule as Rule exposing (Error, Rule)


{-| Reports... REPLACEME

    config =
        [ NoPrimitiveTypeAlias.rule
        ]


## Fail

    a =
        "REPLACEME example to replace"


## Success

    a =
        "REPLACEME example to replace"


## When (not) to enable this rule

This rule is useful when REPLACEME.
This rule is not useful when REPLACEME.


## Try it out

You can try this rule out by running the following command:

```bash
elm-review --template dillonkearns/elm-review-no-primitive-type-alias/example --rules NoPrimitiveTypeAlias
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "NoPrimitiveTypeAlias" ()
        |> Rule.withSimpleDeclarationVisitor declarationVisitor
        |> Rule.fromModuleRuleSchema


declarationVisitor : Node Declaration -> List (Error {})
declarationVisitor node =
    case Node.value node of
        Declaration.AliasDeclaration aliasDeclaration ->
            let
                errorMessage =
                    Rule.error
                        { message = "Primitive type alias for `" ++ Node.value aliasDeclaration.name ++ "`"
                        , details =
                            [ "Type aliases to simple primitives like String or Int can be misleading because you could give them a name, like `type alias UserId = String`, but then use that name anywhere a String is used. That means you could have a home address that is mistakenly labeled as a `UserId`, or an actual user ID string that is labelled as `String`."
                            , "Consider using a custom type, like `type UserId = UserId String` instead so the compiler can give you more useful feedback."
                            ]
                        }
                        (Node.range node)
            in
            case Node.value aliasDeclaration.typeAnnotation of
                TypeAnnotation.Unit ->
                    [ errorMessage ]

                TypeAnnotation.Typed a b ->
                    case Node.value a of
                        ( [], "String" ) ->
                            [ errorMessage ]

                        ( [], "Int" ) ->
                            [ errorMessage ]

                        ( [], "Bool" ) ->
                            [ errorMessage ]

                        _ ->
                            []

                _ ->
                    []

        _ ->
            []
