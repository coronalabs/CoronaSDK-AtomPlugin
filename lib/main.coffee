packageDeps = require 'atom-package-deps'
provider = require './autocomplete-provider'

module.exports =
    config:
      includeArguments:
        type: 'boolean'
        default: true
    activate: ->
        packageDeps.install('autocomplete-corona')
        .then ->
          provider.loadCompletions()

     getAutocompleteProvider: ->
        provider
