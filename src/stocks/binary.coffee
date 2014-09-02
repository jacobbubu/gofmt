{ getType, truncateNumber, isInteger, pad } = require '../utils'
print = require 'printable-string'

MAX_INT = 9007199254740992

findMacFrac = (frac, eLen) ->
    until frac > MAX_INT
        maxFrac = frac
        maxELen = eLen
        frac = frac * 2
        eLen++
    { maxFrac, maxELen }

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params
    numOperand = Number operand
    type = getType operand

    if isNaN numOperand
        return { cursor, output: "%!#{verb}(#{type}=#{operand})" }

    if numOperand >=0
        if flags.removeSign
            sign = ' '
        else if flags.sign
            sign = '+'
        else
            sign = ''
    else
        sign = '-'

    numOperand = Math.abs numOperand
    if isInteger numOperand
        str = numOperand.toString 2
    else
        int = truncateNumber numOperand
        str = numOperand.toString 2
        [_, binFrac] = str.split '.'
        eLen = binFrac.length
        frac = parseInt binFrac, '2'
        { maxFrac, maxELen } = findMacFrac int * Math.pow(2, eLen) + frac, eLen
        str = maxFrac.toString() + 'p' + (-maxELen).toString()

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, sign, paddingRight, flags.zeroPadded
    { cursor, output }
