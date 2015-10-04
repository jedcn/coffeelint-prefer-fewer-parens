twoParensTogether = (api) ->
  prior = api.peek -1
  prior[0] is 'CALL_START' and prior[1] is '('

closingParenWasExplicit = (token) ->
  not token.generated

closingParenAtEndOfLine = (api) ->
  next = api.peek 1
  next[0] is 'TERMINATOR' and next[1] is '\n'

class PreferFewerParens
  rule:
    name: 'prefer_fewer_parens'
    level: 'error'
    message: 'Unnecessary paren'
    description: 'Detects situations where you could use implicit parens'

  constructor: ->

  tokens: ['CALL_END']

  lintToken: (token, api) ->

    return if twoParensTogether api

    if closingParenAtEndOfLine(api) and closingParenWasExplicit token
      context: 'found explicit function invocation'

module.exports = PreferFewerParens
