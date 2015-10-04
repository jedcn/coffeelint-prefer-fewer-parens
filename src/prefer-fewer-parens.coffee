class PreferFewerParens
  rule:
    name: 'prefer_fewer_parens'
    level: 'error'
    message: 'Unnecessary paren'
    description: 'Detects situations where you could use implicit parens'

  lintLine: ->
    true

module.exports = PreferFewerParens
