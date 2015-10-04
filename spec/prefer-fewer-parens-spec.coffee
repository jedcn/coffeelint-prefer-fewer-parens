PreferFewerParens = require '../src/prefer-fewer-parens'

coffeelint = require 'coffeelint'
coffeelint.registerRule PreferFewerParens

config =
  'prefer_fewer_parens':
    level: 'error'

describe 'PreferFewerParens', ->

  describe 'acceptable inputs', ->

    it 'allows parens in invocation with 0 args', ->
      input = """
      alert()
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 0

    it 'allows implicit parens used with a single arg', ->
      input = """
      alert "Hello CoffeeScript!"
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 0

    it 'allows implicit parens used with two args', ->
      input = """
      Math.pow 2, 3
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 0

    it 'allows implicit parens used with a function arg', ->
      input = '''
      runLater ->
        alert "Hello CoffeeScript!"
      '''
      results = coffeelint.lint input, config
      expect(results.length).toEqual 0

    it 'allows parens in all but last of chained function invocations', ->
      input = """
      gulp.src(src)
        .pipe(coffee())
        .pipe(gulp.dest('./src'))
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 3
      expect(result.line).toEqual "  .pipe(gulp.dest('./src'))"


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
