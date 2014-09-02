{ isPositiveInteger } = require './utils'

getWidth = (node, cursor, args, defaultWidth=0) ->
    result =
        width: defaultWidth
        err: null
        cursor: cursor
        badIndex: false
    flags = node.flags
    if flags.w?
        result.width = flags.w
    else if flags.wIndex?
        if flags.wIndex is 0
            newCursor = cursor
        else
            newCursor = flags.wIndex - 1
            if newCursor < 0 or newCursor >= args.length
                result.badIndex = true
                return result

        width = Number args[newCursor]
        if isPositiveInteger Math.abs width
            result.width = width
        else
            result.err = '%!(BADWIDTH)'
        result.cursor = newCursor + 1
    else if not flags.useDefault
        result.width = 0
    result

getPrecision = (node, cursor, args, defaultPrecision=6) ->
    result =
        precision: defaultPrecision
        err: null
        cursor: cursor
        badIndex: false
    flags = node.flags
    if flags.p?
        result.precision = flags.p
    else if flags.pIndex?
        if flags.pIndex is 0
            newCursor = cursor
        else
            newCursor = flags.pIndex - 1
            if newCursor < 0 or newCursor >= args.length
                result.badIndex = true
                return result

        precision = Number args[newCursor]
        if isPositiveInteger precision
            result.precision = precision
        else
            result.err = '%!(BADPREC)'

        result.cursor = newCursor + 1
    else if not flags.useDefault
        result.precision = 0 # for '.f', use 0 instead of 6
    result

getOperand = (node, cursor, args) ->
    result =
        operand: null
        err: null
        cursor: cursor
        badIndex: false
        missing: false
    flags = node.flags
    if flags.opIndex is 0
        newCursor = cursor
        if newCursor >= args.length
            result.missing = true
            return result
    else if flags.opIndex is -1
        newCursor = cursor + 1
        if newCursor >= args.length
            result.missing = true
            return result
    else
        newCursor = flags.opIndex - 1
        if newCursor < 0 or newCursor >= args.length
            result.badIndex = true
            return result

    result.operand = args[newCursor]
    result.cursor = newCursor + 1
    result

module.exports = (node, cursor, args) ->
    output = ''
    flags = node.flags

    widthResult = getWidth node, cursor, args
    output += widthResult.err if widthResult.err?

    precisionResult = getPrecision node, widthResult.cursor, args
    output += precisionResult.err if precisionResult.err?

    operandResult = getOperand node, precisionResult.cursor, args
    output += operandResult.err if operandResult.err?

    processed =
        operand: operandResult.operand
        verb: node.verb
        flags: node.flags
        width: widthResult.width
        precision: precisionResult.precision
        cursor: operandResult.cursor
        output: output
        args: args
        badIndex: widthResult.badIndex or precisionResult.badIndex or operandResult.badIndex
        missing: operandResult.missing