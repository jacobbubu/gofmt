describe 'parseFlags test', ->
    { parseFlags, merge } = require '../lib/utils'

    defaultResult =
        sign: false
        alter: false
        paddingRight: false
        removeSign: false
        zeroPadded: false
        w: null
        p: null
        wIndex: null
        pIndex: null
        useDefault: true
        opIndex: 0

    # it 'fill flags', ->
    #     nodes = [
    #        { text: '+[1]*.[2]*d' }

    #     ]
    #     nodes.forEach (node, index) ->
    #         node.verb = node.text.slice -1
    #         console.log parseFlags(node)
    #         # parseFlags(node).should.eql node.r, JSON.stringify node

    it 'without args indexes', ->
        nodes = [
           { text: 'd',      r: null }
           { text: '4d',     r: { w: 4 } }
           { text: '4.2d',   r: { w: 4, p: 2, useDefault: false } }
           { text: '4.d',    r: { w: 4, useDefault: false  } }
           { text: '.4d',    r: { p: 4, useDefault: false } }
           { text: '.d',     r: { useDefault: false } }
           { text: 'f',      r: null }
           { text: '4f',     r: { w: 4 } }
           { text: '4.2f',   r: { w: 4, p: 2, useDefault: false } }
           { text: '4.f',    r: { w: 4, useDefault: false } }
           { text: '04.2f',  r: { w: 4, p: 2, useDefault: false, zeroPadded: true } }
           { text: '4.200f', r: { w: 4, p: 200, useDefault: false } }
        ]
        nodes.forEach (node, index) ->
            node.verb = node.text.slice -1
            parseFlags(node).should.eql merge(defaultResult, node.r), JSON.stringify node

    it 'with args indexes', ->
        nodes = [
            { text: '[1]*.[2]*d', r: { wIndex: 1, pIndex: 2, useDefault: false } }
            { text: '[1]*.d',     r: { wIndex: 1, useDefault: false } }
            { text: '.[2]*d',     r: { pIndex: 2, useDefault: false } }
            { text: '[1]*.*d',    r: { wIndex: 1, pIndex: 0, useDefault: false } }
            { text: '*.[2]*d',    r: { wIndex: 0, pIndex: 2, useDefault: false } }
            { text: '*.*d',       r: { wIndex: 0, pIndex: 0, useDefault: false } }
            { text: '*.d',        r: { wIndex: 0, useDefault: false } }
            { text: '.*d',        r: { pIndex: 0, useDefault: false } }
            { text: '[1]*.2d',    r: { p: 2, wIndex: 1, useDefault: false } }
            { text: '4.[2]*d',    r: { w: 4, pIndex: 2, useDefault: false} }
        ]
        nodes.forEach (node, index) ->
            node.verb = node.text.slice -1
            parseFlags(node).should.eql merge(defaultResult, node.r), JSON.stringify node

    it 'with operand index', ->
        nodes = [
            { text: '[2]*.[3]*[1]d', r: { wIndex: 2, pIndex: 3, opIndex: 1, useDefault: false} }
            { text: '[2]*.[1]d', r: { wIndex: 2, opIndex: 1, useDefault: false} }
            { text: '.[3]*[1]d', r: { pIndex: 3, opIndex: 1, useDefault: false} }
            { text: '[2]*[1]d', r: { wIndex: 2, opIndex: 1, useDefault: true} }
            { text: '.*[1]d', r: { pIndex: 0, opIndex: 1, useDefault: false} }
            { text: '*.*[1]d', r: { wIndex: 0, pIndex: 0, opIndex: 1, useDefault: false} }
        ]
        nodes.forEach (node) ->
            node.verb = node.text.slice -1
            parseFlags(node).should.eql merge(defaultResult, node.r), JSON.stringify node