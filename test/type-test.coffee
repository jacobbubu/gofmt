describe 'type test', ->
    sprintf = require('../lib/index')()

    it '%T', ->
        data = [
            { args: ['%T'], r: '%!T(MISSING)' }
            { args: ['%T', 1], r: 'number' }
            { args: ['%T', 'str'], r: 'string' }
            { args: ['%T', ->], r: 'function' }
            { args: ['%T', {}], r: 'object' }
            { args: ['%T', new Array], r: 'array' }
            { args: ['%T', new Error], r: 'error' }
            { args: ['%T', new TypeError], r: 'error' }
            { args: ['%T', new Date], r: 'date' }
            { args: ['%T', new RegExp], r: 'regexp' }
            { args: ['%T', null], r: 'null' }
            { args: ['%T', undefined], r: 'undefined' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%T with width and precision', ->
        data = [
            { args: ['%.2T', ->], r: 'fu' }
            { args: ['%4.2T', ->], r: '  fu' }
            { args: ['%04.2T', ->], r: '00fu' }
            { args: ['%-4.2T', ->], r: 'fu  ' }
            { args: ['%[2]*.[3]*[1]T', (->), 4, 2], r: '  fu' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index