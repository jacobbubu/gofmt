{ getType, truncateNumber, pad } = require '../utils'
print = require 'printable-string'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params
    type = getType operand

    if type is 'number'
        value = truncateNumber operand
        if value >= 0
            str = print String.fromCharCode value
            str = "'" + str + "'"
        else
            return { cursor, output: "%!#{verb}(number=#{operand})" }
    else
        str = operand.toString()
        if flags.alter
            str = "`" + str + "`"
        else
            str = '"' + print(str) + '"'

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, '', paddingRight, flags.zeroPadded
    { cursor, output }
