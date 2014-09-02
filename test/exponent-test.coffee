describe 'exponent test', ->
    sprintf = require('../lib/index')()

    it '%e %E', ->
        data = [
            { args: ['%e', 'abc'], r: '%!e(string=abc)' }
            { args: ['%e', 1.1], r: '1.100000e+0' }
            { args: ['%0.20e', 999999999.999999999], r: '1.00000000000000000000e+9' }
            { args: ['%020e', 1.1], r: '0000000001.100000e+0' }
            { args: ['%E', 1.1], r: '1.100000E+0' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index