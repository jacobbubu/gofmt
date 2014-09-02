{ getType, isInteger, pad } = require '../utils'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params

    numOperand = Number operand
    if isNaN(numOperand) and not isInteger(numOperand)
        return { cursor, output: "%!#{verb}(#{getType(operand)}=#{operand})" }

    str = String.fromCharCode numOperand

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, '', paddingRight, flags.zeroPadded
    { cursor, output }
