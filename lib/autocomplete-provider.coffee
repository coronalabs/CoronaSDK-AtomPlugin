fs = require 'fs'
path = require 'path'

module.exports =
    selector: '.source.lua'
    disableForSelector: '.source.lua .comment, .source.lua .string'

    inclusionPriority: 1
    excludeLowerPriority: false
    filterSuggestions: true

    getSuggestions: ( { editor, prefix, bufferPosition } ) ->
        prefix = @getPrefix(editor, bufferPosition)

        if prefix.length is 0
            return []

        @findSuggestions( @completions, prefix )

    findSuggestions: ( completions, prefix ) ->
        suggestions = []
        for item in completions
            if @compareStrings( item.displayText, prefix )
                suggestions.push( @buildSuggestion( item ) )
        suggestions

    buildSuggestion: ( item ) ->
        suggestion =
            displayText: item.displayText
            snippet: item.snippet
            type: item.type
            description: item.description
            descriptionMoreURL: item.descriptionMoreUrl

    loadCompletions: ->
        @completions = {}
        fs.readFile path.resolve( __dirname, '..', './data/corona-data.json' ), ( error, data ) =>
            @completions = JSON.parse( data ) unless error?
            return

    compareStrings: ( a, b ) ->
        a[0].toLowerCase() is b[0].toLowerCase()

    getPrefix: (editor, bufferPosition) ->
      regex = /[a-zA-Z0-9_\.]*$/
      line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
      line.match(regex)?[0] or ''
