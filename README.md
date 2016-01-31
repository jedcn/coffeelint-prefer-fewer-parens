# coffeelint-prefer-fewer-parens

> Detects situations where you *could have* avoided using parens

## Overview

This project defines a [CoffeeLint][CoffeeLint] rule named
`prefer_fewer_parens`.

This rule detects situations where you *could have* used implicit parens.

[CoffeeLint][CoffeeLint] has a rule named `no_implicit_parens`. This
is "sort of" the opposite of that.

### Before

```coffeescript
runLater(->
  anotherFn(1, 2)
  gulp.fn(someArg)
      .pipe(anotherArg)
      .pipe(lastArg)
)

alert(1)
alert(1, 2)
```

### After

```coffeescript
runLater ->
  anotherFn 1, 2
  gulp.fn(someArg)
      .pipe(anotherArg)
      .pipe lastArg

alert 1
alert 1, 2
```

See the [specs for additional examples][specs].

[specs]: spec/prefer-fewer-parens-spec.coffee

## Installation

1. Setup [CoffeeLint][CoffeeLint] in your project and verify that it
   works
2. Add this module as a `devDependency`: `npm install -D coffeelint-prefer-fewer-parens`
3. Update your `coffeelint.json` configuration file as described below.

## Configuration

Add the following snippet to your `coffeelint.json` config:

```json
{
  "prefer_fewer_parens": {
    "module": "coffeelint-prefer-fewer-parens",
    "level": "warn"
  }
}
```

[CoffeeLint]: http://coffeelint.org
