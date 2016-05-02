# gulp plugin module

through = require 'through2'
path = require 'path'
BlackList = require './BlackList'
meta = require './package.json'


module.exports = (arg) ->
    {scope, strict, quiet} = if arg? then arg else {}
    unless scope? then scope = 'project'
    unless strict? then strict = true
    unless quiet? then quiet = true

    transform = (file, encode, callback) ->
        # do nothing in the stream
        new BlackList meta.blackListURL
            .then (blackList) ->

                if scope is 'project'
                    blackList.checkPackage '.', {strict, quiet}

                else if scope is 'module'
                    console.log this
                    for child in module.children
                        ext = path.extname child.id
                        base = path.basename child.id, ext
                        blackList.check base, {strict, quiet}

                else if scope is 'stream'
                    console.log this

                callback()

            .catch (error) ->
                console.error error
                callback()

    flush = (callback) ->
        callback()
    return through.obj transform, flush
