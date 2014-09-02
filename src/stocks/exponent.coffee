{ getType, isInteger, pad } = require '../utils'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params

    numOperand = Number operand
    if isNaN(numOperand)
        return { cursor, output: "%!#{verb}(#{getType(operand)}=#{operand})" }

    if numOperand >=0
        if flags.removeSign
            sign = ' '
        else if flags.sign
            sign = '+'
        else
            sign = ''
    else
        sign = '-'

    frac = if flags.useDefault then 6 else precision
    str = numOperand.toExponential(frac).toString()
    str = str.toUpperCase() if verb is 'E'

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, sign, paddingRight, flags.zeroPadded
    { cursor, output }
