lib     = require './lib'
should  = require 'should'
express = require 'express' # create mock server


describe 'test of test', ->
    it 'should work well.', ->
        true.should.be.true()


describe 'class `BlackList`, ', ->

    # prepare examples
    blackListValidExample =
        'gulp-foo': 'blacklisted one.'
        'gulp-bar': 'blacklisted one.'

    # create mock server
    app = null
    hostname = 'localhost'
    port = 3000
    before ->
        app = require('express')()
        app.get '/', (req, res) ->
            rew.header 'content-type', 'application/json'
            res.send blackListValidExample
        app.listen port, hostname

    describe 'constructor, ', ->
        it 'should be a prototype function.', ->
            (typeof lib.BlackList).should.be.exactly 'function'

        it 'should accept blackList as an object.', (done) ->
            blackList = new BlackList blackListValidExample
            (typeof blackList).should.be.exactly 'function'

        it 'should accept url asynchronously.', (done) ->
            blackList = new Blacklist 'http://someURLasString'
            blackList.should.have.property 'then'
            blackList.catch (error) ->
                (error instanceof Error).should.be.true()
                done()

        it 'should be polimorphically thenable after it accept blacklist object.', (done) ->
            blackList = new BlackList blackListValidExample
            blackList.should.have.property 'then'
            blackList.then (instance) ->
                (error instanceof Error).should.be.true()
                done()



return

`
describe 'test of `call` method', ->

    it 'should do nothing without function', () ->
        lib.call 'with non-function arguments.'

    it 'should call function with argument.', (done) ->
        func = (done) ->
            done()
        lib.call func, [done]


describe 'test of `getBlacklist` method', ->

    it 'should failes with a nonsense url argument', (done) ->
        lib.getBlacklist 'http://nonsense-ur.l', (error, blacklist) ->
            (error instanceof Error).should.be.true()
            should(blacklist).not.be.ok() # if null
            done()

    it 'should return blacklist without 1st argument of url', (done) ->
        lib.getBlacklist (error, blacklist) ->
            should(error).not.be.ok() # if null
            (typeof blacklist).should.equal 'object'
            done()

    it 'should return blacklist with 1st argument of url', (done) ->
        lib.getBlacklist lib.BLACKLIST_URL, (error, blacklist) ->
            should(error).not.be.ok() # if null
            (typeof blacklist).should.equal 'object'
            done()


describe 'test of `check` method', ->

    it 'should success without arguments.', (done) ->
        lib.check (error, result) ->
            should(error).not.be.ok() # if null
            (typeof result.isBlacklisted).should.equal 'boolean'
            (Array.isArray result.blacklist).should.be.true()
            done()

    it 'should success with path arguments.', (done) ->
        lib.check { path: '.' }, (error, result) ->
            should(error).not.be.ok() # if null
            (typeof result.isBlacklisted).should.equal 'boolean'
            (Array.isArray result.blacklist).should.be.true()
            done()

    it 'should fail with nonsense url.', (done) ->
        lib.check { path: '.', blacklistURL:'http://nonsense-ur.l' }, (error, result) ->
            (error instanceof Error).should.be.true()
            should(result).not.be.ok() # if null
            done()

    it 'should fail with blacklisted one.', (done) ->
        lib.check { name: 'gulp-requirejs' }, (error, result) ->
            (error instanceof Error).should.be.true()
            should(result).not.be.ok() # if null
            done()
