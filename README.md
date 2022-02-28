# elm-review-no-primitive-type-alias

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to REPLACEME.


## Provided rules

- [`NoPrimitiveTypeAlias`](https://package.elm-lang.org/packages/dillonkearns/elm-review-no-primitive-type-alias/1.0.0/NoPrimitiveTypeAlias) - Reports REPLACEME.


## Configuration

```elm
module ReviewConfig exposing (config)

import NoPrimitiveTypeAlias
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ NoPrimitiveTypeAlias.rule
    ]
```


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template dillonkearns/elm-review-no-primitive-type-alias/example
```
