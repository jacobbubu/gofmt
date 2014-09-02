describe 'quote test', ->
    sprintf = require('../lib/index')()

    it '%q for string', ->
        data = [
            { args: ['%q', '\u038b\tabc'], r: '"\\u038b\\tabc"' }
            { args: ['%#q', '\u038b\tabc'], r: "`\u038b\tabc`" }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%q for number', ->
        data = [
            { args: ['%q', 0x38b], r: "'\\u038b'" }
            { args: ['%#q', 0x38b], r: "'\\u038b'" }
            { args: ['%#q', 7], r: "'\\a'" }
            { args: ['%#q', 7.1], r: "'\\a'" }
            { args: ['%#q', -7], r: "%!q(number=-7)" }
            { args: ['%#q', 0x7f], r: "'\\x7f'" }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index
