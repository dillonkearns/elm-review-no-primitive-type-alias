module NoPrimitiveTypeAlias exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Declaration as Declaration exposing (Declaration)
import Elm.Syntax.Node as Node exposing (Node)
import Elm.Syntax.TypeAnnotation as TypeAnnotation exposing (TypeAnnotation)
import Review.ModuleNameLookupTable as ModuleNameLookupTable exposing (ModuleNameLookupTable)
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
    Rule.newModuleRuleSchemaUsingContextCreator "NoPrimitiveTypeAlias" initialContext
        |> Rule.withDeclarationEnterVisitor declarationVisitor
        |> Rule.fromModuleRuleSchema


type alias Context =
    { lookupTable : ModuleNameLookupTable }


initialContext : Rule.ContextCreator () Context
initialContext =
    Rule.initContextCreator
        (\lookupTable () -> { lookupTable = lookupTable })
        |> Rule.withModuleNameLookupTable


declarationVisitor : Node Declaration -> Context -> ( List (Error {}), Context )
declarationVisitor node context =
    case Node.value node of
        Declaration.AliasDeclaration aliasDeclaration ->
            if isPrimitive context.lookupTable (Node.value aliasDeclaration.typeAnnotation) then
                ( [ Rule.error
                        { message = "Primitive type alias for `" ++ Node.value aliasDeclaration.name ++ "`"
                        , details =
                            [ "Type aliases to simple primitives like String or Int can be misleading because you could give them a name, like `type alias UserId = String`, but then use that name anywhere a String is used. That means you could have a home address that is mistakenly labeled as a `UserId`, or an actual user ID string that is labelled as `String`."
                            , "Consider using a custom type, like `type UserId = UserId String` instead so the compiler can give you more useful feedback."
                            ]
                        }
                        (Node.range node)
                  ]
                , context
                )

            else
                ( [], context )

        _ ->
            ( [], context )


isPrimitive : ModuleNameLookupTable -> TypeAnnotation -> Bool
isPrimitive lookupTable annotation =
    case annotation of
        TypeAnnotation.Unit ->
            True

        TypeAnnotation.Typed a b ->
            case ( ModuleNameLookupTable.moduleNameFor lookupTable a |> Maybe.withDefault [], Node.value a |> Tuple.second ) of
                ( [ "Basics" ], "Int" ) ->
                    True

                ( [ "Basics" ], "Float" ) ->
                    True

                ( [ "Basics" ], "Bool" ) ->
                    True

                ( [ "String" ], "String" ) ->
                    True

                _ ->
                    False

        _ ->
            False
