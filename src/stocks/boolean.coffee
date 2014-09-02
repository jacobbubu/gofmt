{ getType, pad } = require '../utils'

module.exports = (params) ->
    { width, precision, cursor, verb, flags, output, operand } = params
    type = getType operand
    switch type
        when 'string'
            boolValue = operand.length > 0
        when 'number'
            boolValue = operand isnt 0
        when 'boolean'
            boolValue = operand
        when 'array'
            boolValue = operand.length isnt 0
        else
            boolValue = operand?

    str = boolValue.toString()

    paddingRight = flags.paddingRight or width < 0
    width = Math.abs width

    output += pad str, width, '', paddingRight, flags.zeroPadded
    { cursor, output }