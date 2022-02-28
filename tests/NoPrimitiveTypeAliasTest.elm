module NoPrimitiveTypeAliasTest exposing (all)

import NoPrimitiveTypeAlias exposing (rule)
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "NoPrimitiveTypeAlias"
        [ test "type alias for plain String" <|
            \() ->
                """module A exposing (..)

type alias JustAPlainString = String

type alias JustAPlainInt = Int

type alias JustAPlainBool = Bool

type alias JustAPlainUnit = ()

type NotAPlainString = NotAPlainString String

type alias RecordAliasesAreOkay = { first : String, last : String }

"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ error "JustAPlainString" "String"
                        , error "JustAPlainInt" "Int"
                        , error "JustAPlainBool" "Bool"
                        , error "JustAPlainUnit" "()"
                        ]
        ]


error : String -> String -> Review.Test.ExpectedError
error aliasName aliasedType =
    Review.Test.error
        { message = "Primitive type alias for `" ++ aliasName ++ "`"
        , details =
            [ "Type aliases to simple primitives like String or Int can be misleading because you could give them a name, like `type alias UserId = String`, but then use that name anywhere a String is used. That means you could have a home address that is mistakenly labeled as a `UserId`, or an actual user ID string that is labelled as `String`."
            , "Consider using a custom type, like `type UserId = UserId String` instead so the compiler can give you more useful feedback."
            ]
        , under = "type alias " ++ aliasName ++ " = " ++ aliasedType
        }
