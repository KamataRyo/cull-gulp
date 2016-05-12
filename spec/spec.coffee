CullGulp = require '../CullGulp'
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

describe 'class `CullGulp`', ->

    describe 'constructor', ->
        it 'should be a prototype function.', ->
            (typeof CullGulp).should.be.exactly 'function'

        it 'should accept black-list as an object asynchronously.(make it polimorphic to url request)', (done) ->
            cullGulp = new CullGulp blackListValidExample
            cullGulp.should.have.property 'then'
            cullGulp.then (cullGulp) ->
                cullGulp.list.should.be.equal blackListValidExample
                done()

        it 'should fail if given non-effective url.', (done) ->
            (new CullGulp "http://aaa.a").catch -> done()

        it 'should success if given effective url.', (done) ->
            new CullGulp "http://#{hostname}:#{port}"
                .then (cullGulp) ->
                    cullGulp.list.should.deepEqual blackListValidExample
                    done()

    describe 'method `check`', ->
        it 'should be a function.', (done) ->
            new CullGulp "http://#{hostname}:#{port}"
                .then (cullGulp) ->
                    (typeof cullGulp.check).should.equal 'function'
                    done()

        it 'should check if given string is registered as black-list at the URL.', (done) ->
            new CullGulp "http://#{hostname}:#{port}"
                .then (cullGulp) ->
                    cullGulp.check('gulp-foo', quiet:true).should.be.true()
                    cullGulp.check('gulp-baz', quiet:true).should.be.false()
                    done()

        it 'should check if given string is registered as black-list at the list.', (done) ->
            new CullGulp blackListValidExample
                .then (cullGulp) ->
                    cullGulp.check('gulp-foo', quiet:true).should.be.true()
                    cullGulp.check('gulp-baz', quiet:true).should.be.false()
                    done()

        it 'should throw error with strict mode.', (done) ->
            new CullGulp blackListValidExample
                .then (cullGulp) ->
                    try
                        result = cullGulp.check 'gulp-bar', {strict:true, quiet:true}
                        result.should.be.true()
                    catch error
                        (error instanceof Error).should.be.true()
                        done()


    describe 'method `checkPackage`', ->
        it 'should check out the package with black-listed modules.', (done) ->
            new CullGulp blackListValidExample
                .then (cullGulp) ->
                    result = cullGulp.checkPackage "#{__dirname}/fixtures/packageFoo", {quiet:true}
                    result.should.be.true()
                    done()

        it 'should check out the package with not black-listed modules.', (done) ->
            new CullGulp blackListValidExample
                .then (cullGulp) ->
                    result = cullGulp.checkPackage "#{__dirname}/fixtures/packageBar", {quiet:true}
                    result.should.be.false()
                    done()

        it 'should check out the package with black-listed modules in strict mode.', (done) ->
            new CullGulp blackListValidExample
                .then (cullGulp) ->
                    result = cullGulp.checkPackage "#{__dirname}/fixtures/packageFoo", {strict:true, quiet:true}
                .catch (error) ->
                    (error instanceof Error).should.be.true()
                    done()

        it 'should check out the package with not black-listed modules in strict mode.', (done) ->
            new CullGulp blackListValidExample
                .then (cullGulp) ->
                    result = cullGulp.checkPackage "#{__dirname}/fixtures/packageBar", {strict:true, quiet:true}
                    result.should.be.false()
                    done()
