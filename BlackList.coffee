request = require 'request'
BLACKLIST_URL = 'http://gulpjs.com/plugins/blackList.json'

class BlackList
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
                            reject new Error 'unknown server response type.'
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
            message = "[notice] `#{id}` is blacklisted,for #{@list[id]}"
        else
            message = "[information] `#{id}` is not blacklisted."

        if !quiet
            console.log message

        if (strict is true) and blackListed
            throw new Error message
        else
            return blackListed



    checkPackage: (path, {strict, quiet, dependencies, devDependencies}) ->
        unless strict? then strict = false
        unless quiet? then quiet = false
        unless dependencies then dependencies = true
        unless devDependencies then devDependencies = true

        meta = require "#{path}/package.json"
        ids = []
        if dependencies
            ids = ids.concat Object.keys meta.dependencies
        if devDependencies
            ids = ids.concat Object.keys meta.devDependencies
        for id in ids
            @check id, {strict, quiet}

module.exports = BlackList

return


#
# # call if defined as function
# call = (func, args) ->
#     if typeof func is 'function'
#         func.apply null, args
#
#
# getBlacklist = (arg1, arg2) ->
#     if typeof arg1 is 'string'
#         [url, callback] = [arg1, arg2]
#     else if typeof arg1 is 'function'
#         [url, callback] = [BLACKLIST_URL, arg1]
#     else
#         throw new Error 'invalid argument(s).'
#
#     request url, (error, res, body) ->
#         if !error and res.statusCode is 200
#             call callback, [null, JSON.parse body]
#         else
#             call callback, [error, null]
#
#
# check = (arg1, arg2)->
#     strict = false
#     path = '.'
#     if typeof arg1 is 'object'
#         [{strict, path, names, blacklistURL}, callback] = [arg1, arg2]
#     else if typeof arg1 is 'function'
#         [{strict, path, names, blacklistURL}, callback] = [{}, arg1]
#     else
#         throw new Error 'invalid argument(s).'
#
#     if names?
#         if typeof names isnt Array
#             names = [names]
#
#         {dependencies, devDependencies} =
#             dependencies: Object.keys require("#{path}/package.json").dependencies
#             devDewget pendencies: Object.keys require("#{path}/package.json").devDependencies
#         names = dependencies.concat devDependencies
#
#
#     url = if blacklistURL? then blacklistURL else BLACKLIST_URL
#     getBlacklist url, (error, list) ->
#         if error?
#             call callback, [error, null]
#         else
#             message = ''
#             result =
#                 isBlacklisted: false
#                 blacklist: []
#             for name in names
#                 isBlacklisted = name in Object.keys list
#                 result.isBlacklisted = result.isBlacklisted and isBlacklisted
#                 if isBlacklisted
#                     result.blacklist.push name
#                     message += "[notice] package `#{name}` is blacklisted, for #{list[name]}\n"
#                 else
#                     message += "[information] package `#{name}` is not blacklisted.\n"
#
#             console.log message
#             call callback, [null, result]
#
#
#
# module.exports = {BLACKLIST_URL, call, getBlacklist, check}
