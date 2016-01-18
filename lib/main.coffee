provider = require './autocomplete-provider'

module.exports =
    activate: ->
        provider.loadCompletions()

     getAutocompleteProvider: ->
        provider
