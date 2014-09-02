{ getType, truncateTo, pad } = require '../utils'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, operand, output } = params
    numOperand = Number operand
    if isNaN numOperand
        return { cursor, output: output + "%!#{verb}(#{getType(operand)}=#{operand})" }

    if numOperand >=0
        if flags.removeSign
            sign = ' '
        else if flags.sign
            sign = '+'
        else
            sign = ''
    else
        sign = '-'

    bound = if flags.useDefault then 6 else precision
    if Math.abs(numOperand) >= Math.pow 10, bound
        if flags.useDefault
            precision = 7
        else
            precision-- if precision > 0
        absValueStr = numOperand.toExponential(precision).toString()
        absValueStr = str.toUpperCase() if verb is 'E'
    else
        absNumOperand = Math.abs numOperand
        if flags.useDefault
            absValueStr = absNumOperand.toString()
        else
            intPart = parseInt(absNumOperand).toString()
            digits = precision - intPart
            if digits > 0
                absValueStr = truncateTo absNumOperand, digits, false
            else
                absValueStr = absNumOperand

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad absValueStr, width, sign, paddingRight, flags.zeroPadded
    { cursor, output: output }