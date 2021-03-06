request = require 'request'
color   = require 'cli-color'
# unless Promise? then Promise = require 'es6-promise'
errorText  = (label, message) -> "[#{color.red(label)}] #{message}"
noticeText = (label, message) -> "[#{color.cyan(label)}] #{message}"
warnText   = (label, message) -> "[#{color.yellow(label)}] #{message}"
okText     = (label, message) -> "[#{color.green(label)}] #{message}"

class CullGulp
    constructor: (arg) ->
        # if passed as url..
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
                            reject errorText 'error', 'invalid server response.'
                    else
                        reject errorText 'error', 'http error.'
        # if passed as blacklist object..
        else if typeof arg is 'object'
            @list = arg
            return new Promise (resolve) =>
                resolve @
        else
            return new Promise(resolve, reject) =>
                throw new Error ErrorText 'Error', 'invalid arguments.'


    check: (id, {strict, quiet, throwError}) ->
        unless strict? then strict = false
        unless quiet? then quiet = false
        unless throwError? then throwError = false


        blackListed = id in Object.keys @list
        if blackListed
            if strict
                message = errorText 'error', "'#{id}' is marked in blacklist.\n ┗━" + errorText 'reason', @list[id]
            else
                message = warnText 'warn', "'#{id}' is marked in blacklist.\n ┗━" + warnText 'reason', @list[id]
        else
            message = noticeText 'information', "'#{id}' is not marked in the blacklist."
        unless quiet
            console.log message

        if throwError then throw new Error()
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
        blackList = {}
        for id in ids
            checked = @check id, {strict, quiet, throwError:false}
            blackListed = blackListed or checked
            if blackListed then blackList[id] = @list[id]

        if blackListed
            if strict is true
                console.log errorText 'error', 'some gulpplugins are marked in the blackList.'
                throw new Error()
            else unless quiet
                console.log warnText 'warn', 'some gulpplugins are marked in the blackList.'
        else unless quiet
            console.log okText 'ok', 'No gulpplugins marked in the blackList found.'

        return blackListed




module.exports = CullGulp
