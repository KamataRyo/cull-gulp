app = require './index'
should = require 'should'

describe 'test of test', ->
    it 'should works well.', ->
        true.should.equal true


describe 'test of `getBlacklist` method', ->

    it 'should failes with a nonsense url argument', (done) ->
        app.getBlacklist {
            url: 'http://noncense-ur.l'
            failure: (error, statusCode)->
                console.log error, statusCode
                done()
        }

    it 'should return blacklist', (done) ->
        app.getBlacklist {
            success: (blacklist) ->
                (typeof blacklist).should.equal 'object'
                done()
        }
