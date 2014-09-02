describe 'unicode test', ->
    sprintf = require('../lib/index')()

    it '%U', ->
        data = [
            { args: ['%U', 'abc'], r: '%!U(string=abc)' }
            { args: ['%U', 1.1], r: '%!U(number=1.1)' }
            { args: ['%U', 0x41], r: 'U+0041' }
            { args: ['%#U', 0x41], r: "U+0041 'A'" }
            { args: ['%U', 0x07], r: 'U+0007' }
            { args: ['%#U', 0x07], r: "U+0007" }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index