PreferFewerParens = require '../src/prefer-fewer-parens'

coffeelint = require 'coffeelint'
coffeelint.registerRule PreferFewerParens

config =
  'prefer_fewer_parens':
    level: 'error'

describe 'PreferFewerParens', ->

  describe 'desired usage of parens', ->

    #
    # These are examples of CoffeeLint code that this rule pushes you
    # to create.
    #
    desired =
      zeroArgs:
        desc: 'You need parens when you do not have args'
        text: '''
          fn()
        '''
      oneArgImplicit:
        desc: 'You should use implicit parens with one arg'
        text: '''
          alert 'Hello CoffeeScript'
        '''
      oneArgWithFunctionImplicit:
        desc: 'You should use implicit parens with one arg that is a function'
        text: '''
          runLater ->
        '''
      implicitInsideFunctionsAlso:
        desc: 'You should use implicit parens inside functions that you pass'
        text: '''
          runLater ->
            alert 'Hello CoffeeScript!'
        '''
      twoArgsImplicit:
        desc: 'You should use implicit parens with two args'
        text: '''
          Math.pow 2, 3
        '''
      chainedInvocations:
        desc: 'You can use explicit parens when chaining, but not at the end'
        text: '''
          gulp.fn(someArg)
            .pipe(anotherArg)
            .pipe lastArg
        '''

    it 'expects parens in invocation with 0 args', ->
      results = coffeelint.lint desired.zeroArgs.text, config
      expect(results.length).toEqual 0

    it 'expects implicit parens used with a single arg', ->
      results = coffeelint.lint desired.oneArgImplicit.text, config
      expect(results.length).toEqual 0

    it 'expects implicit parens used with a single arg that is a function', ->
      results = coffeelint.lint desired.oneArgWithFunctionImplicit.text, config
      expect(results.length).toEqual 0

    it 'allows implicit parens used with two args', ->
      results = coffeelint.lint desired.twoArgsImplicit.text, config
      expect(results.length).toEqual 0

    it 'allows implicit parens used with a function arg', ->
      results = coffeelint.lint desired.oneArgWithFunctionImplicit.text, config
      expect(results.length).toEqual 0

    it 'allows parens in all but last of chained function invocations', ->
      results = coffeelint.lint desired.chainedInvocations.text, config
      expect(results.length).toEqual 0

  describe 'problematic inputs', ->

    it 'rejects unneeded parens with one arg', ->
      input = """
      alert("Hello CoffeeScript!")
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 1
      expect(result.line).toEqual 'alert("Hello CoffeeScript!")'

    it 'rejects unneeded parens with two args', ->
      input = """
      Math.pow(2, 3)
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 1
      expect(result.line).toEqual 'Math.pow(2, 3)'

    it 'rejects unneeded parens used with a single function argument', ->
      input = '''
      runLater(->)
      '''
      results = coffeelint.lint input, config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 1
      expect(result.line).toEqual 'runLater(->)'

    it 'rejects unneeded parens outside and inside a function', ->
      input = '''
      runLater(->
        alert("Hello CoffeeScript")
      )
      '''

      results = coffeelint.lint input, config
      expect(results.length).toEqual 2

      # inside
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 2
      expect(result.line).toEqual '  alert("Hello CoffeeScript")'

      # outside
      result = results[1]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 3
      expect(result.line).toEqual ')'

    it 'rejects unneeded parens used inside a function', ->
      input = '''
      runLater ->
        alert("Hello CoffeeScript")
      '''

      results = coffeelint.lint input, config
      expect(results.length).toEqual 1

      # inside
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 2
      expect(result.line).toEqual '  alert("Hello CoffeeScript")'

    it 'rejects unneeded parens used anywhere inside a function', ->
      input = '''
      runLater ->
        alert("First")
        alert("Second")
        alert("Third")
      '''

      results = coffeelint.lint input, config
      expect(results.length).toEqual 3

      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 2
      expect(result.line).toEqual '  alert("First")'

      result = results[1]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 3
      expect(result.line).toEqual '  alert("Second")'

      result = results[2]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 4
      expect(result.line).toEqual '  alert("Third")'
