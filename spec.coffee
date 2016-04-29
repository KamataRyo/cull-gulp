lib = require './lib'
should = require 'should'


describe 'test of test', ->
    it 'should works well.', ->
        true.should.be.true()


describe 'test of `call` method', ->

    it 'should do nothing without function', ->
        lib.call 'with non-function arguments.'

    it 'should call function with argument.', (done) ->
        func = (done) ->
            done()
        lib.call func, [done]


describe 'test of `getBlacklist` method', ->

    it 'should failes with a nonsense url argument', (done) ->
        lib.getBlacklist 'http://nonsense-ur.l', (error, blacklist) ->
            (error instanceof Error).should.be.true()
            should(blacklist).not.be.ok()
            done()

    it 'should return blacklist without 1st argument of url', (done) ->
        lib.getBlacklist (error, blacklist) ->
            should(error).not.be.ok()
            (typeof blacklist).should.equal 'object'
            done()

    it 'should return blacklist with 1st argument of url', (done) ->
        lib.getBlacklist lib.BLACKLIST_URL, (error, blacklist) ->
            should(error).not.be.ok()
            (typeof blacklist).should.equal 'object'
            done()


describe 'test of `check` method', ->

    it 'should success without arguments.', (done) ->
        lib.check (error, result) ->
            should(error).not.be.ok()
            (typeof result.isBlacklisted).should.equal 'boolean'
            (Array.isArray result.blacklist).should.be.true()
            done()

    it 'should success with path arguments.', (done) ->
        lib.check { path: './' }, (error, result) ->
            should(error).not.be.ok()
            (typeof result.isBlacklisted).should.equal 'boolean'
            (Array.isArray result.blacklist).should.be.true()
            done()

    it 'should fail with nonsense url.', (done) ->
        lib.check { path: './', blacklistURL:'http://nonsense-ur.l' }, (error, result) ->
            (error instanceof Error).should.be.true()
            should(result).not.be.ok()
            done()
