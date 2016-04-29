request = require 'request'
blacklistURL = 'http://gulpjs.com/plugins/blackList.json'


app = {}

app.getBlacklist = ({url, failure, success}) ->
    unless url? then url = blacklistURL

    request url, (error, res, body) ->
        if !error and res.statusCode is 200
            if typeof success is 'function'
                success JSON.parse body
        else
            if typeof failure is 'function'
                failure error


app.check = ({mode, path, name, failure, success})->
    unless path? and name?
        err = new Error 'one of path or name properties is required in the argument.'
        if (typeof failure) is 'function' then failure err
        if mode is 'strict' then throw err

    # if typeof arguments[0] is 'object'
    #     name = arguments[0].package
    #     blacklist = arguments[0].blacklist
    #     this.getBlacklist {
    #         success: (blacklist) ->
    #             result = name in Object.keys blacklist
    #             if result
    #                 reason = blacklist[name]
    #                 message = "[notice] package `#{name}` is blacklisted, for #{reason}"
    #             else
    #                 message = "[information] package `#{name}` is not blacklisted."
    #             if typeof this.arguments[0].callback is 'function'
    #                 console.log message
    #                 arguments[0].callback result
    #     }


module.exports = app
