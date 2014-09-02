{ getType, truncateNumber, repeatChars, pad } = require '../utils'

module.exports = (params) ->

    convertNumber = (value) ->
        tmp = Math.abs(value).toString(8)

        if not flags.useDefault and precision > tmp.length
            tmp = repeatChars(precision - tmp.length, '0') + tmp
        if flags.alter and tmp[0] isnt '0'
            tmp = '0' + tmp
        tmp

    { width, precision, cursor, verb, flags, output, operand } = params
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
    else
        return { cursor, output: "%!#{verb}(#{type}=#{operand})" }

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, sign, paddingRight, false
    { cursor, output }