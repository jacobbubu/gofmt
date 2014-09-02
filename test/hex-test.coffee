describe 'hex test', ->
    sprintf = require('../lib/index')()

    it '%x string', ->
        data = [
            { args: ['%x', 'abc'], r: '616263' }
            { args: ['%#x', 'abc'], r: '0x610x620x63' }
            { args: ['% x', 'abc'], r: '61 62 63' }
            { args: ['% #x', 'abc'], r: '0x61 0x62 0x63' }
            { args: ['%10x', 'abc'], r: '    616263' }
            { args: ['%-10x', 'abc'], r: '616263    ' }
            { args: ['%x', '中文'], r: '4e2d6587' }
            { args: ['%#x', '中文'], r: '0x4e2d0x6587' }
            { args: ['% #x', '中文ABC'], r: '0x4e2d 0x6587 0x41 0x42 0x43' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%X string', ->
        data = [
            { args: ['%#X', '中文'], r: '0X4E2D0X6587' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%x number', ->
        data = [
            { args: ['%x', 65536], r: '10000' }
            { args: ['%x', 1.234], r: '1' }
            { args: ['%.4x', 255], r: '00ff' }
            { args: ['%#.4x', 255], r: '0x00ff' }
            { args: ['%#.4x', -255], r: '-0x00ff' }
            { args: ['%+#.4x', 255], r: '+0x00ff' }
            { args: ['%10.4x', 255], r: '      00ff' }
            { args: ['%010.4x', 255], r: '      00ff' }
            { args: ['%#010.4x', 255], r: '    0x00ff' }
            { args: ['%-10.4x', 255], r: '00ff      ' }
            { args: ['%#-10.4x', 255], r: '0x00ff    ' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%X number', ->
        data = [
            { args: ['%#.4X', 255], r: '0X00FF' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index