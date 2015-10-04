# coffeelint-prefer-fewer-parens

> Detects situations where you *could have* avoided using explicit parens

## Installation

1. Setup [CoffeeLint](http://coffeelint.org) in your project and verify that it
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
