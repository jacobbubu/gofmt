getType = (obj) ->
    Object.prototype.toString.call(obj).slice(8, -1).toLowerCase()

truncateNumber = (number) ->
    Math[if number < 0 then 'ceil' else 'floor'](number)

merge = (obj1, obj2) ->
    result = {}
    if obj1?
        for k, v of obj1
            result[k]  = v
    if obj2?
        for k, v of obj2
            result[k]  = v
    result

parseFlags = (node) ->

    makePattern = (verb) ->
        p = [
            '(?:'
                '('                                         # only width
                    '(?:[1-9]\\d*)'                             # by digit
                    '|'                                         # or
                    '(?:(?:\\[\\d+\\]){1}\\*)'                  # by index [1]*
                ')'
                '|'                                         # or
                '(?:'                                       # width + precition
                    '(?:'                                       # withd start
                        '('                                         # returns like '6' or '[1]*''
                            '(?:[1-9]\\d*)'                         # by digit
                            '|'                                     # or
                            '(?:(?:\\[\\d+\\])?\\*)'                # by index [1]*
                        ')?'
                        '(?:\\.)'                                   # decimal point
                    ')'                                         # withd end
                    '{1}'                                       # width MUST be existing
                    '(?:'                                       # precition start
                        '('
                            '(?:\\d+)'                              # by digit
                            '|'                                     # or
                            '(?:(?:\\[\\d+\\])?\\*)'                # by index [index]* or *
                        ')?'                                        # precition could be ignored
                    ')'                                         # precition end
                ')'
            ')?'                                            # width + precition could be ignored
            '(?:'                                           # operand index start
                '(?:\\[(\\d+)\\])'                              # operand index
                '|'                                             # or
                '(\\*)'                                         # just moving cursor to the next
            ')?'                                            # operand index could be ignored
            '\\x' + verb.charCodeAt(0).toString(16)         # tail verb
            '$'
        ].join ''
        # Matches
        # [1]: only width
        # [2]: width part
        # [3]: precision part
        # [4]: operand index
        # [5]: operand cursor moving '*d'
        reg = new RegExp p
        reg

    result =
        sign: false
        alter: false
        paddingRight: false
        removeSign: false
        zeroPadded: false
        w: null
        p: null
        wIndex: null
        pIndex: null
        useDefault: false
        opIndex: 0 # 0: use next argument, -1: skip one argument (next of next)

    text = node.text
    for c in text
        if c is '+'
            result.sign = true
        else if c is '-'
            result.paddingRight = true
        else if c is '#'
            result.alter = true
        else if c is ' '
            result.removeSign = true
        else if c is '0'
            result.zeroPadded = true
        else
            break

    pattern = makePattern node.verb
    match = pattern.exec node.text
    return result if not match?

    result.useDefault = match[0].indexOf('.') < 0

    extractValue = (text) ->
        value = null; index = null
        indexPattern = /(?:\[(\d+)\])/
        if text is '*'
            index = 0
        else if (indexMatch = indexPattern.exec text)?
            index = Number indexMatch[1]
        else
            value = Number text
        [ value, index ]

    if match[1]?
        [result.w, result.wIndex] = extractValue match[1]
    else
        if match[2]?
            [result.w, result.wIndex] = extractValue match[2]

    if match[4]?
        result.opIndex = Number match[4]
    else if match[5] is '*'
        result.opIndex = -1

    if match[3]?
        [result.p, result.pIndex] = extractValue match[3]
    return result

isInteger = (value) ->
    if isNaN value
        false
    else
        value is parseInt value

isPositiveInteger = (value) ->
    if isInteger value
        value > 0
    else
        false

repeatChars = (length, ch=' ') ->
    Array(length+1).join(ch)

padRight = (value, length, ch=' ') ->
    value.toString() + Array(length+1).join(ch)

pad = (str, width, sign='', paddingRight, zeroPadded) ->
    length = sign.length + str.length
    if length < width
        if paddingRight
            # for right padding, we always use space as the padded char
            padStr = repeatChars width - length
            result = sign + str + padStr
        else
            if zeroPadded
                padStr = repeatChars width - length, '0'
                result = sign + padStr + str
            else
                padStr = repeatChars width - length
                result = padStr + sign + str
    else
        result = sign + str
    result

truncateTo = (num, digits, padded = true) ->
    d = 1 / Math.pow 10, digits + 3
    m = Math.pow 10, digits
    tmp = (Math.abs(Math.round( (num + d) * m ) / m)).toString()
    [int, frac] = tmp.split '.'
    if frac
        if frac.length < digits and padded
            padRight tmp, digits - frac.length, '0'
        else
            tmp
    else if digits > 0 and padded
        padRight int + '.', digits, '0'
    else
        int

module.exports =
    getType: getType
    truncateNumber: truncateNumber
    merge: merge
    parseFlags: parseFlags
    isInteger: isInteger
    isPositiveInteger: isPositiveInteger
    repeatChars: repeatChars
    padRight: padRight
    pad: pad
    truncateTo: truncateTo