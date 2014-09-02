describe 'number test', ->
    sprintf = require('../lib/index')()

    it '%%', ->
        sprintf('20%% increasing').should.equal '20% increasing'

    it '%d', ->
        data = [
            { args: ['%d'], r: '%!d(MISSING)' }
            { args: ['%d', 1.0], r: '1' }
            { args: ['%d%%', 1.0], r: '1%' }
            { args: ['%d %d %d', 5, 10, 15], r: '5 10 15' }
            { args: ['%*d', 1, 2, 3, 4, 5], r: '2' }
            { args: ['%*d %*d %*d', 1, 2, 3, 4, 5], r: '2 4 %!d(MISSING)' }
            { args: ['%[3]d %[2]d %[1]d', 5, 10, 15], r: '15 10 5' }
            { args: ['%[2]d %d %d', null, 10, 15], r: '10 15 %!d(MISSING)' }
            { args: ['%d', 'NaN', 1, 2, 3, 4, 5], r: '%!d(string=NaN)' }
            { args: ['%4d', 1], r: '   1' }
            { args: ['%04d', 1], r: '0001' }
            { args: ['%-4d', 1], r: '1   ' }
            { args: ['%-04d', 1], r: '1   ' }
            { args: ['%-04d', 1], r: '1   ' }
            { args: ['%[2]*.[1]d', 1, -4], r: '1   ' }
            { args: ['%[2]*.[1]d', 1, 4], r: '   1' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index

    it '%f', ->
        data = [
            { args: ['%f'], r: '%!f(MISSING)' }
            { args: ['%f', 1.0], r: '1.000000' }
            { args: ['%.f', 1.0], r: '1' }
            { args: ['%f%%', 1.0], r: '1.000000%' }
            { args: ['%.f%%', 1.0], r: '1%' }
            { args: ['%4.f%%', 1.0], r: '   1%' }
            { args: ['%5.2f', 1.23], r: ' 1.23' }
            { args: ['%5.2f', 1.235], r: ' 1.24' }
            { args: ['%5.2f', -1.235], r: '-1.23' }
            { args: ['%.6f', -1.235], r: '-1.235000' }
            { args: ['%16.6f', -1.235], r: '       -1.235000' }
            { args: ['%-16.6f', -1.235], r: '-1.235000       ' }
            { args: ['%-016.6f', -1.235], r: '-1.235000       ' }
            { args: ['%16.6f', 1.235], r: '        1.235000' }
            { args: ['%-16.6f', 1.235], r: '1.235000        ' }
            { args: ['%016.6f', 1.235], r: '000000001.235000' }
            { args: ['%+9.6f', 1.235], r: '+1.235000' }
            { args: ['% 9.6f', 1.235], r: ' 1.235000' }
            { args: ['% 9.6f', -1.235], r: '-1.235000' }
            { args: ['%010.6f', -1.235], r: '-01.235000' }
            { args: ['%f %f %f', 5, 10, 15], r: '5.000000 10.000000 15.000000' }
            { args: ['%[3]f %[2]f %[1]f', 5, 10, 15], r: '15.000000 10.000000 5.000000' }
            { args: ['%[2]f %f %f', null, 10, 15], r: '10.000000 15.000000 %!f(MISSING)' }
            { args: ['%f', 'NaN'], r: '%!f(string=NaN)' }
            { args: ['%[2]*.[1]f', 1.0, 4], r: '   1' }
        ]
        data.forEach (t, index) ->
            sprintf.apply(null, t.args).should.be.equal t.r, 'case-- ' + index