request = require 'request'
# unless Promise? then Promise = require 'es6-promise'

class CullGulp
    constructor: (arg) ->
        if typeof arg is 'string'
            @path = arg
            return new Promise (resolve, reject) =>
                request @path, (error, res, body) =>
                    if !error and res.statusCode is 200
                        # depends on server settings
                        if typeof body is 'string'
                            @list = JSON.parse body
                            resolve @
                        else if typeof body is 'object'
                            @list = body
                            resolve @
                        else
                            reject new Error 'invalid server response.'
                    else
                        reject error # http request error

        else if typeof arg is 'object'
            @list = arg
            return new Promise (resolve) =>
                resolve @
        else
            return new promise(resolve, reject) =>
                reject new Error 'invalid argument.'


    check: (id, {strict, quiet}) ->
        unless strict? then strict = false
        unless quiet? then quiet = false

        blackListed = id in Object.keys @list
        if blackListed
            message = "[notice] `#{id}` is marked in blacklist. #{@list[id]}"
        else
            message = "[information] `#{id}` is not marked in the blacklist."

        if !quiet
            console.log message

        if (strict is true) and blackListed
            throw new Error message

        return blackListed



    checkPackage: (path, {strict, quiet, dependencies, devDependencies}) ->
        unless strict? then strict = false
        unless quiet? then quiet = false
        unless dependencies then dependencies = true
        unless devDependencies then devDependencies = true

        meta = require "#{path}/package.json"
        ids = []
        if dependencies and meta.dependencies?
            ids = ids.concat Object.keys meta.dependencies
        if devDependencies and meta.devDependencies?
            ids = ids.concat Object.keys meta.devDependencies

        blackListed = false
        for id in ids
            try
              blackListed = blackListed or @check id, {strict, quiet}
            catch error
              if blackListed is false then blackListed = {}
              blackListed[id] = @list[id]

        if !quiet and !blackListed
            console.log '[information] No gulpplugins marked in the blackList found.'

        if (strict is true) and blackListed
            throw new Error '[notice] some gulpplugins are marked in the blackList.',

        return blackListed




module.exports = CullGulp
