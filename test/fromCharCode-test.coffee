describe 'fromCharCode test', ->
    sprintf = require('../lib/index')()

    it '%c', ->
        data = [
            { args: ['%c', 'abc'], r: '%!c(string=abc)' }
            { args: ['%cBCD', 65], r: 'ABCD' }
            { args: ['%4c', 65], r: '   A' }
            { args: ['%-4c', 65], r: 'A   ' }
            { args: ['%04c', 65], r: '000A' }
            { args: ['%c', -65], r: '﾿' }
            { args: ['%04c', -65], r: '000﾿' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index