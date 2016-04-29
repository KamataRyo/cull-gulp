app = require './index'
should = require 'should'


describe 'test of test', ->
    it 'should works well.', ->
        true.should.be.true()


describe 'test of `call` method', ->

    it 'should do nothing without function', ->
        app.call 'with non-function arguments.'

    it 'should call function with argument.', (done) ->
        func = (done) ->
            done()
        app.call func, [done]


describe 'test of `getBlacklist` method', ->

    it 'should failes with a nonsense url argument', (done) ->
        app.getBlacklist 'http://nonsense-ur.l', (error, blacklist) ->
            (error instanceof Error).should.be.true()
            should(blacklist).not.be.ok()
            done()

    it 'should return blacklist without 1st argument of url', (done) ->
        app.getBlacklist (error, blacklist) ->
            should(error).not.be.ok()
            (typeof blacklist).should.equal 'object'
            done()

    it 'should return blacklist with 1st argument of url', (done) ->
        app.getBlacklist app.BLACKLIST_URL, (error, blacklist) ->
            should(error).not.be.ok()
            (typeof blacklist).should.equal 'object'
            done()


describe 'test of `check` method', ->

    it 'should success without arguments.', (done) ->
        app.check (error, result) ->
            should(error).not.be.ok()
            (typeof result).should.equal 'boolean'
            done()

    it 'should success with path arguments.', (done) ->
        app.check { path: './' }, (error, result) ->
            should(error).not.be.ok()
            (typeof result).should.equal 'boolean'
            done()

    it 'should fail with nonsense url.', (done) ->
        app.check { path: './', blacklistURL:'http://nonsense-ur.l' }, (error, result) ->
            (error instanceof Error).should.be.true()
            should(result).not.be.ok()
            done()
