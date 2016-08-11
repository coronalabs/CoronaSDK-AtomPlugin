packageDeps = require 'atom-package-deps'
provider = require './autocomplete-provider'

module.exports =
    activate: ->
        packageDeps.install()
        .then ->
          provider.loadCompletions()

     getAutocompleteProvider: ->
        provider
