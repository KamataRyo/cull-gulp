request = require 'request'
blacklistURL = 'http://gulpjs.com/plugins/blackList.json'


app = {}

app.getBlacklist = (arg) ->
    unless arg.url? then arg.url = blacklistURL

    request arg.url, (error, res, body) ->
        if !error and res.statusCode is 200
            if typeof arg.success is 'function'
                arg.success JSON.parse body
        else
            if typeof arg.failure is 'function'
                arg.failure error


module.exports = app
