{ getType, pad } = require '../utils'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params
    str = operand.toString()
    if not flags.useDefault
        str = str.slice 0, precision

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, '', paddingRight, flags.zeroPadded
    { cursor, output }
