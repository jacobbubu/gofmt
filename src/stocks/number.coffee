{
    getType
    truncateNumber
    pad
    truncateTo
} = require '../utils'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params
    numOperand = Number operand
    if isNaN numOperand
        return { cursor, output: output + "%!#{verb}(#{getType(operand)}=#{operand})" }

    if numOperand >= 0
        if flags.removeSign
            sign = ' '
        else if flags.sign
            sign = '+'
        else
            sign = ''
    else
        sign = '-'

    if verb is 'd'
        numOperand = truncateNumber numOperand
        absValueStr = Math.abs(numOperand).toString()
    else
        absValueStr = truncateTo numOperand, precision

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad absValueStr, width, sign, paddingRight, flags.zeroPadded
    { cursor, output }