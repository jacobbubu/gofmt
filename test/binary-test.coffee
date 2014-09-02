describe 'binary test', ->
    sprintf = require('../lib/index')()

    it '%b for floating number', ->
        data = [
            { args: ['%b', 1.1], r: '4953959590107546p-52' }
            { args: ['%b', 100.1], r: '7043911292184166p-46' }
            { args: ['%b', 1000000000000.3], r: '8192000000002458p-13' }
            { args: ['%b', -0.3], r: '-5404319552844595p-54' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%b for integer', ->
        data = [
            { args: ['%b', 1024], r: '10000000000' }
            { args: ['%b', -1024], r: '-10000000000' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index