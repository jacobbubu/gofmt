describe 'hex test', ->
    sprintf = require('../lib/index')()

    it '%o', ->
        data = [
            { args: ['%o', 'abc'], r: '%!o(string=abc)' }
            { args: ['%o', 1], r: '1' }
            { args: ['%.3o', 1], r: '001' }
            { args: ['%.o', 8], r: '10' }
            { args: ['%#.o', 8], r: '010' }
            { args: ['%#o', 8], r: '010' }
            { args: ['%o', -8], r: '-10' }
            { args: ['%#o', -8], r: '-010' }
            { args: ['%#8o', -8], r: '    -010' }
            { args: ['%#08o', -8], r: '    -010' }
            { args: ['%-#8o', -8], r: '-010    ' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index