describe 'filesize test', ->
    sprintf = require('../lib/index')()

    it '%Z', ->
        data = [
            { args: ['%Z', 'abc'], r: '%!Z(string=abc)' }
            { args: ['%Z', 1024], r: '1.00 kB' }
            { args: ['%Z', 1024*1024], r: '1.00 MB' }
            { args: ['%.1Z', 1024], r: '1.0 kB' }
            { args: ['%#Z', 1000], r: '1.00 kB' }
            { args: ['%#Z', 1000*1000], r: '1.00 MB' }
            { args: ['%#.1Z', 1000], r: '1.0 kB' }
            { args: ['%16Z', 1024], r: '         1.00 kB' }
            { args: ['%016Z', 1024], r: '0000000001.00 kB' }
            { args: ['%-16Z', 1024], r: '1.00 kB         ' }
            { args: ['%-16Z', -1024], r: '-1.00 kB        ' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%z', ->
        data = [
            { args: ['%z', 'abc'], r: '%!z(string=abc)' }
            { args: ['%z', 1024], r: '8.00 kb' }
            { args: ['%z', 1024*1024], r: '8.00 Mb' }
            { args: ['%.1z', 1024], r: '8.0 kb' }
            { args: ['%#z', 1000], r: '8.00 kb' }
            { args: ['%#.1z', 1000], r: '8.0 kb' }
            { args: ['%16z', 1024], r: '         8.00 kb' }
            { args: ['%016z', 1024], r: '0000000008.00 kb' }
            { args: ['%-16z', 1024], r: '8.00 kb         ' }
            { args: ['%-16z', -1024], r: '-8.00 kb        ' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index