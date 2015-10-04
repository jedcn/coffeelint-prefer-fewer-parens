PreferFewerParens = require '../src/prefer-fewer-parens'

coffeelint = require 'coffeelint'
coffeelint.registerRule PreferFewerParens

describe 'PreferFewerParens', ->

  describe 'smoke test', ->
    beforeEach ->
      lintyCode = '''
        # Anything will fail
      '''
      config =
        prefer_fewer_parens:
          level: 'warn'

      @errors = coffeelint.lint(lintyCode, config)

    it 'has an error on line 1', ->
      expect(@errors.length).toBe 1
      error = @errors[0]
      expect(error.level).toBe 'warn'
      expect(error.lineNumber).toBe 1
      expect(error.rule).toBe 'prefer_fewer_parens'
