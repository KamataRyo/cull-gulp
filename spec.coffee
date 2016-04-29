app = require './index'
should = require 'should'


describe 'test of test', ->
    it 'should works well.', ->
        true.should.equal true


describe 'test of `getBlacklist` method', ->

    it 'should failes with a nonsense url argument', (done) ->
        app.getBlacklist {
            url: 'http://nonsense-ur.l'
            failure: (error)->
                done()
        }

    it 'should return blacklist', (done) ->
        app.getBlacklist {
            success: (blacklist) ->
                (typeof blacklist).should.equal 'object'
                done()
        }


describe 'test of `check` method', ->

    it 'should fail without path and name arguments', (done) ->
        app.check {
            path: undefined
            name: undefined
            failure: (error) ->
                (error instanceof Error).should.equal true
                done()
        }

    it 'should fail without path and name arguments in strict mode', (done) ->
        try
          app.check {
              mode: 'strict'
              path: undefined
              name: undefined
          }
        catch error
            (error instanceof Error).should.equal true
            done()


    # it "should check if the module named as property 'package' is blacklisted.", (done) ->
    #     app.check {
    #         package: 'gulp-coffee'
    #         callback: (result, error) ->
    #             (typeof result).should.equal 'boolean'
    #             done()
    #     }
