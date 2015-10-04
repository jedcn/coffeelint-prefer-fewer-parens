PreferFewerParens = require '../src/prefer-fewer-parens'

coffeelint = require 'coffeelint'
coffeelint.registerRule PreferFewerParens

config =
  'prefer_fewer_parens':
    level: 'error'

describe 'PreferFewerParens', ->

  describe 'acceptable inputs', ->

    it 'is ok with a fn invocation without args', ->
      results = coffeelint.lint 'alert()', config
      expect(results.length).toEqual 0

    it 'is ok with a basic fn invocation', ->
      results = coffeelint.lint 'alert "Hello CoffeeScript!"', config
      expect(results.length).toEqual 0

    it 'is ok with a basic method invocation', ->
      results = coffeelint.lint 'Math.pow 2, 3', config
      expect(results.length).toEqual 0

    it 'is ok with a fn invocation that takes a fn as an arg', ->
      input = '''
      runLater ->
        alert "Hello CoffeeScript!"
      '''
      results = coffeelint.lint input, config
      expect(results.length).toEqual 0

    it 'is ok with mixed explicit/implicit paren usage', ->
      input = """
      gulp.task 'compile', ->
        gulp.src(src)
          .pipe(coffee())
          .pipe(gulp.dest('./src'))
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 0

  describe 'problematic inputs', ->

    it 'rejects a fn invocation where unneeded parens are used', ->
      results = coffeelint.lint 'alert("Hello CoffeeScript!")', config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 1
      expect(result.line).toEqual 'alert("Hello CoffeeScript!")'

    it 'rejects a method invocation where unneeded parens are used', ->
      results = coffeelint.lint 'Math.pow(2, 3)', config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 1
      expect(result.line).toEqual 'Math.pow(2, 3)'

    it 'rejects an invocation that takes a fn arg with unneeded parens', ->
      input = '''
      runLater(->
        alert "Hello CoffeeScript!")
      '''
      results = coffeelint.lint input, config
      expect(results.length).toEqual 1
      result = results[0]
      expect(result.rule).toEqual 'prefer_fewer_parens'
      expect(result.lineNumber).toEqual 2
      expect(result.line).toEqual '  alert "Hello CoffeeScript!")'

    it 'rejects mixed explicit/implict parens if last use is explicit', ->
      input = """
      gulp.task('compile', ->
        gulp.src(src)
          .pipe(coffee())
          .pipe(gulp.dest('./src'))
      )
      """
      results = coffeelint.lint input, config
      expect(results.length).toEqual 1
