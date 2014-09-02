describe 'string test', ->
    sprintf = require('../lib/index')()

    it '%s', ->
        data = [
            { args: ['%s'], r: '%!s(MISSING)' }
            { args: ['%s', 1], r: '1' }
            { args: ['%s', 'str'], r: 'str' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%s with width and precision', ->
        data = [
            { args: ['%.2s', '123456'], r: '12' }
            { args: ['%4.2s', '123456'], r: '  12' }
            { args: ['%04.2s', '123456'], r: '0012' }
            { args: ['%-4.2s', '123456'], r: '12  ' }
            { args: ['%[2]*.[3]*[1]s', '123456', 4, 2], r: '  12' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index