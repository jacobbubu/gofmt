describe 'g test', ->
    sprintf = require('../lib/index')()

    it '%g string', ->
        data = [
            { args: ['%g', 'abc'], r: '%!g(string=abc)' }
            { args: ['%g', 1], r: '1' }
            { args: ['%g', 1.234], r: '1.234' }
            { args: ['%.3g', 1.2345], r: '1.23' }
            { args: ['%.3g', -1.2345], r: '-1.23' }
            { args: ['%8.3g', -1.2345], r: '   -1.23' }
            { args: ['%08.3g', -1.2345], r: '-0001.23' }
            { args: ['%g', 6666666.6], r: '6.6666666e+6' }
            { args: ['%.3g', 6666666.6], r: '6.67e+6' }
            { args: ['%.g', 6666666.6], r: '7e+6' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index