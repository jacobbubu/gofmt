describe 'boolean test', ->
    sprintf = require('../lib/index')()

    it '%t', ->
        data = [
            { args: ['%t', true], r: 'true' }
            { args: ['%t', false], r: 'false' }
            { args: ['%t', ''], r: 'false' }
            { args: ['%t', '1'], r: 'true' }
            { args: ['%t', ->], r: 'true' }
            { args: ['%t', {}], r: 'true' }
            { args: ['%t', null], r: 'false' }
            { args: ['%t', undefined], r: 'false' }
            { args: ['%t', new Array], r: 'false' }
            { args: ['%t', new Array 1], r: 'true' }
            { args: ['%t', 0], r: 'false' }
            { args: ['%010t', 0], r: '00000false' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index