fs = require 'fs'
path = require 'path'

module.exports =
    selector: '.source.lua'
    disableForSelector: '.source.lua .comment, .source.lua .string'

    inclusionPriority: 1
    excludeLowerPriority: false
    filterSuggestions: false

    getSuggestions: ( { editor, prefix, bufferPosition } ) ->
        prefix = @getPrefix(editor, bufferPosition)

        if prefix.length is 0
            return []

        @findSuggestions( @completions, prefix )

    findSuggestions: ( completions, prefix ) ->
        suggestions = []
        if completions?
            for item in completions
                if item? && prefix? && item.displayText? && @compareStrings( item.displayText, prefix )
                    suggestions.push( @buildSuggestion( item , prefix.indexOf('.')) )
        suggestions

    buildSuggestion: ( item, hasDot ) ->
        includeArguments = atom.config.get('autocomplete-corona.includeArguments')
        snippet = if hasDot is -1 then item.snippet else item.snippet.substring(item.snippet.indexOf('.') + 1)

        if !includeArguments
          if snippet.indexOf('()') == -1
            if snippet.indexOf('(') != -1
              snippet = snippet.substring(0, snippet.indexOf('(')) + '(${1})'

        suggestion =
            displayText: item.displayText
            snippet: snippet
            type: item.type
            description: item.description
            descriptionMoreURL: item.descriptionMoreUrl

    loadCompletions: ->
        fs.readFile path.resolve( __dirname, '..', './data/corona-data.json' ), ( error, data ) =>
            @completions = JSON.parse( data ) unless error?
            unless @completions?
                    atom.notifications.addError('Corona Autocomplete data is corrupt. Please, reinstall the plugin.')
                    @completions = []
            return

    compareStrings: ( a, b ) ->
        maxLength = if a.length < b.length then a.length else b.length
        a.substring(0, maxLength) is b.substring(0, maxLength)

    getPrefix: (editor, bufferPosition) ->
      regex = /[a-zA-Z0-9_\.]*$/
      line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
      line.match(regex)?[0] or ''
