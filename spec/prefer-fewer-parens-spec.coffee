PreferFewerParens = require '../src/prefer-fewer-parens'

coffeelint = require 'coffeelint'
coffeelint.registerRule PreferFewerParens

config =
  'prefer_fewer_parens':
    level: 'error'

describe 'PreferFewerParens', ->

  describe 'CoffeeScript with fewer parens', ->
    #
    # These are examples of CoffeeLint code that this rule pushes you
    # to create.
    #
    # The general idea is to not use parens unless you have
    # to.
    #
    # However-- some parens are allowed because there are times (say,
    # when chaining) when you *could* get away with it but it's less
    # readable.
    #
    # If this looks good to you, check out prefer_fewer_parens!
    #
    desired = [
      rule: 'You must use parens when you do not have args'
      script: '''
        fn()
      '''
    ,
      rule: 'You should use implicit parens with one arg'
      script: '''
        alert 'CoffeeScript'
      '''
    ,
      rule: 'You should use implicit parens with one arg that is a function'
      script: '''
        runLater ->
      '''
    ,
      rule: 'You should use implicit parens with two args'
      script: '''
        Math.pow 2, 3
      '''
    ,
      rule: 'You should use implicit parens within functions that you pass'
      script: '''
        runLater ->
          fn()

        runLater ->
          fn 'CoffeeScript'

        runLater ->
          fn 1, 2, 3
      '''
    ,
      rule: 'You can use explicit parens when chaining, but not at the end'
      script: '''
        gulp.fn(someArg)
          .pipe(anotherArg)
          .pipe lastArg
      '''
    ]

    #
    # Verify that each item generates no problems when linted.
    #
    for desiredCoffee in desired
      do (desiredCoffee) ->
        it desiredCoffee.rule, ->
          results = coffeelint.lint desiredCoffee.script, config
          expect(results.length).toEqual 0

  describe 'CoffeeScript with too many parens', ->

    rejected = [
      rule: 'You cannot use parens with a single, basic argument'
      script: '''
        fn('CoffeeScript')
      '''
      problems: [
        lineNumber: 1
        badCoffee: "fn('CoffeeScript')"
      ]
    ,
      rule: 'You cannot use parens with two single, basic arguments'
      script: '''
        Math.pow(2, 3)
      '''
      problems: [
        lineNumber: 1
        badCoffee: 'Math.pow(2, 3)'
      ]
    ,
      rule: 'You cannot use parens when passing a function as an argument'
      script: '''
        runLater(->)

        runLater(->
          fn()
        )

        runLater(=>
          @fn()
        )
      '''
      problems: [
        lineNumber: 1
        badCoffee: 'runLater(->)'
      ,
        lineNumber: 5
        badCoffee: ')'
      ,
        lineNumber: 9
        badCoffee: ')'
      ]
    ,
      rule: 'You cannot use unnecessary parens inside of functions'
      script: '''
        someFn ->
          fn('first')
          fn('second')
          fn('third')
      '''
      problems: [
        lineNumber: 2
        badCoffee: "  fn('first')"
      ,
        lineNumber: 3
        badCoffee: "  fn('second')"
      ,
        lineNumber: 4
        badCoffee: "  fn('third')"
      ]
    ]

    #
    # Verify that each "rejected" item generates the problems
    # specified above when linted.
    #
    for rejectedCoffee in rejected
      do (rejectedCoffee) ->
        it rejectedCoffee.rule, ->
          results = coffeelint.lint rejectedCoffee.script, config
          expect(results.length).toEqual rejectedCoffee.problems.length
          for result, i in results
            problem = rejectedCoffee.problems[i]
            expect(result.rule).toEqual 'prefer_fewer_parens'
            expect(result.lineNumber).toEqual problem.lineNumber
            expect(result.line).toEqual problem.badCoffee
