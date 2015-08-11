fuzzysearch = require('fuzzysearch')
path = require('path')
fs = require('fs')

provider =
  getTokens: (key) ->
    unless @cache?
      filename = path.join(__dirname, 'tokens.txt')
      source = fs.readFileSync(filename, encoding: 'utf-8')
      @cache = source.split("\n").map (line) ->
        [token, type] = line.split(', ')
        { text: token, type: if type is 'function' then 'function' else 'constant'  }
    @cache
  selector: '.source.eso-lua'
  getSuggestions: (options) ->
    new Promise (resolve) =>
      query = @getTokens().filter (item) ->
        fuzzysearch(options.prefix, item.text)
      resolve query[0..20]

module.exports =
  provider: ->
    provider
