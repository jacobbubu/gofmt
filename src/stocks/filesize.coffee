filesize = require 'filesize'
{ getType, truncateTo, pad } = require '../utils'

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

    absValueStr = truncateTo numOperand, precision
    bits = verb is 'z'
    round = if flags.useDefault then 2 else precision
    if flags.alter
        withSuffix = filesize +absValueStr, { bits: bits, round: round }
    else
        withSuffix = filesize +absValueStr, { base: 2, bits: bits, round: round }

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs(width)

    output += pad withSuffix, width, sign, paddingRight, flags.zeroPadded
    { cursor, output: output }