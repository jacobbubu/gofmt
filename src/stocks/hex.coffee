{ getType, truncateNumber, repeatChars, pad } = require '../utils'

module.exports = (params) ->

    convertNumber = (value) ->
        tmp = Math.abs(value).toString(16)
        tmp = tmp.toUpperCase() if verb is 'X'
        if not flags.useDefault and precision > tmp.length
            tmp = repeatChars(precision - tmp.length, '0') + tmp
        tmp = xMark + tmp if flags.alter
        tmp

    convertString = (value) ->
        result = []
        for ch in value
            tmp = ch.charCodeAt(0).toString(16)
            tmp = tmp.toUpperCase() if verb is 'X'
            tmp = '0' + tmp if tmp.length % 2 is 1
            tmp = xMark + tmp if flags.alter
            result.push tmp
        result.join if flags.removeSign then ' ' else ''

    { width, precision, cursor, verb, flags, output, operand } = params
    xMark = '0' + verb
    type = getType operand
    if type is 'number'
        value = truncateNumber operand
        str = convertNumber value
        if value >=0
            if flags.removeSign
                sign = ' '
            else if flags.sign
                sign = '+'
            else
                sign = ''
        else
            sign = '-'
    else if type is 'string'
        value = operand
        str = convertString value
        sign = ''
    else
        return { cursor, output: "%!#{verb}(#{type}=#{operand})" }

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, sign, paddingRight, false
    { cursor, output }