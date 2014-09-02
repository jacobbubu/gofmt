{ getType, merge, parseFlags } = require './utils'
preProcess = require './preProcess'

stocks =
    'v': require './stocks/string'
    's': require './stocks/string'
    'T': require './stocks/type'
    'd': require './stocks/number'
    'f': require './stocks/number'
    'F': require './stocks/number'
    'x': require './stocks/hex'
    'X': require './stocks/hex'
    'o': require './stocks/oct'
    'q': require './stocks/quote'
    'b': require './stocks/binary'
    'U': require './stocks/unicode'
    'c': require './stocks/fromCharCode'
    'e': require './stocks/exponent'
    'E': require './stocks/exponent'
    'g': require './stocks/g'
    'G': require './stocks/g'
    't': require './stocks/boolean'
    'z': require './stocks/filesize'
    'Z': require './stocks/filesize'

stockFlags = ['+', '-', '#', ' ', '0']

module.exports = (plugins) ->
    verbs = merge stocks, plugins
    verbsPattern = /^\x25(?:[0-9\+\-\#\.\*\[\]\x20]*)(?:[a-zA-Z])/
    flagsPattern =
    cache = {}

    sprintf = ->
        fmt = arguments[0]
        args = Array.prototype.slice.call arguments, 1

        parse = (fmt) ->
            _fmt = fmt; parseTree = []
            while _fmt
                if (match = /^[^\x25]+/.exec _fmt)?
                    parseTree.push { text: match[0] }
                    _fmt = _fmt.slice match[0].length
                else if (match = /^\x25{2}/.exec _fmt)?
                    # escaped %%
                    parseTree.push { text: '%' }
                    _fmt = _fmt.slice match[0].length
                else if (match = verbsPattern.exec _fmt)?
                    node = { text: match[0].slice(1), verb: match[0].slice -1 }
                    node.flags = parseFlags node
                    parseTree.push node
                    _fmt = _fmt.slice match[0].length
                else
                    parseTree.push { text: _fmt }
                    _fmt = ''
            parseTree

        format = (parseTree, args) ->
            # DO NOT CHANGE parseTree in this stage
            cursor = 0
            output = parseTree.map (node) ->
                text = node.text
                verb = node.verb
                return text if not verb?
                curr = args[cursor]

                result = preProcess node, cursor, args
                if result.badIndex
                    cursor = result.cursor
                    return "%!#{verb}(BADINDEX)"
                else if result.missing
                    cursor = result.cursor
                    return "%!#{verb}(MISSING)"

                result.handlers = verbs
                handler = verbs[verb]
                if handler?
                    result = handler result
                    cursor = result.cursor
                    return result.output
                else
                    cursor++
                    return "%!#{verb}(#{getType(result.operand)}=#{result.operand})"

            output.join ''

        parseTree = cache[fmt] ? (cache[fmt] = parse fmt)
        result = format parseTree, args