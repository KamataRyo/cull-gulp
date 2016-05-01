BlackList = require './BlackList'
should    = require 'should'
express   = require 'express' # create mock server


describe 'test of test', ->
    it 'should work well.', ->
        true.should.be.true()

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
        res.header 'Content-Type', 'application/json'
        res.status 200
        res.send blackListValidExample
    app.listen port, hostname

describe 'class `BlackList`', ->

    describe 'constructor', ->
        it 'should be a prototype function.', ->
            (typeof BlackList).should.be.exactly 'function'

        it 'should accept url asynchronously.', (done) ->
            blackList = new BlackList 'http://someURLasString'
            blackList.should.have.property 'then'
            blackList.catch (error) ->
                (error instanceof Error).should.be.true()
                done()

        it 'should accept blacklist as an object asynchronously.(make it polimorphic to url request)', (done) ->
            blackList = new BlackList blackListValidExample
            blackList.should.have.property 'then'
            blackList.then (blackList) ->
                blackList.list.should.be.equal blackListValidExample
                done()

        it 'should success if given effective url.', (done) ->
            new BlackList "http://#{hostname}:#{port}"
                .then (blackList) ->
                    blackList.list.should.deepEqual blackListValidExample
                    done()


    describe 'method `check`', ->
        it 'should be a function.', (done) ->
            new BlackList "http://#{hostname}:#{port}"
                .then (blackList) ->
                    (typeof blackList.check).should.equal 'function'
                    done()

        it 'should check if given string is registered as blacklist at the URL.', (done) ->
            new BlackList "http://#{hostname}:#{port}"
                .then (blackList) ->
                    blackList.check('gulp-foo', quiet:true).should.be.true()
                    blackList.check('gulp-baz', quiet:true).should.be.false()
                    done()

        it 'should check if given string is registered as blacklist at the list.', (done) ->
            new BlackList blackListValidExample
                .then (blackList) ->
                    blackList.check('gulp-foo', quiet:true).should.be.true()
                    blackList.check('gulp-baz', quiet:true).should.be.false()
                    done()

        it 'should throw error with strict mode.', (done) ->
            new BlackList blackListValidExample
                .then (blackList) ->
                    try
                        result = blackList.check 'gulp-bar', {strict:true, quiet:true}
                        result.should.be.true()
                    catch error
                        (error instanceof Error).should.be.true()
                        done()


    describe 'method `checkPackage`', ->
        it 'should check the package.', (done) ->
            new BlackList blackListValidExample
                .then (blackList) ->
                    result = blackList.checkPackage '.', {strict:true, quiet:true}
                    console.log result
                    done()
                .catch (e) ->
                    console.log e



after -> true
    # console.log app


return


# describe 'test of `call` method', ->
#
#     it 'should do nothing without function', () ->
#         lib.call 'with non-function arguments.'
#
#     it 'should call function with argument.', (done) ->
#         func = (done) ->
#             done()
#         lib.call func, [done]
#
#
# describe 'test of `getBlacklist` method', ->
#
#     it 'should failes with a nonsense url argument', (done) ->
#         lib.getBlacklist 'http://nonsense-ur.l', (error, blacklist) ->
#             (error instanceof Error).should.be.true()
#             should(blacklist).not.be.ok() # if null
#             done()
#
#     it 'should return blacklist without 1st argument of url', (done) ->
#         lib.getBlacklist (error, blacklist) ->
#             should(error).not.be.ok() # if null
#             (typeof blacklist).should.equal 'object'
#             done()
#
#     it 'should return blacklist with 1st argument of url', (done) ->
#         lib.getBlacklist lib.BLACKLIST_URL, (error, blacklist) ->
#             should(error).not.be.ok() # if null
#             (typeof blacklist).should.equal 'object'
#             done()
#
#
# describe 'test of `check` method', ->
#
#     it 'should success without arguments.', (done) ->
#         lib.check (error, result) ->
#             should(error).not.be.ok() # if null
#             (typeof result.isBlacklisted).should.equal 'boolean'
#             (Array.isArray result.blacklist).should.be.true()
#             done()
#
#     it 'should success with path arguments.', (done) ->
#         lib.check { path: '.' }, (error, result) ->
#             should(error).not.be.ok() # if null
#             (typeof result.isBlacklisted).should.equal 'boolean'
#             (Array.isArray result.blacklist).should.be.true()
#             done()
#
#     it 'should fail with nonsense url.', (done) ->
#         lib.check { path: '.', blacklistURL:'http://nonsense-ur.l' }, (error, result) ->
#             (error instanceof Error).should.be.true()
#             should(result).not.be.ok() # if null
#             done()
#
#     it 'should fail with blacklisted one.', (done) ->
#         lib.check { name: 'gulp-requirejs' }, (error, result) ->
#             (error instanceof Error).should.be.true()
#             should(result).not.be.ok() # if null
#             done()
