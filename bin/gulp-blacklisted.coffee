`#!/usr/bin/env node
`

app = require 'commander'
BlackList = require ('../BlackList')

app
    .version require('../package.json').version
    .option '-p --path <path>',     'Set path to project root directory'
    .option '-n --name <name>',     'Set typical npm name to check'
    .option '-s --strict', 'raise error if black-listed'
    .option '-q --quiet',   'show whether black-listed to stdout.'
    .parse process.argv

path   = app.path
name   = app.name
strict = app.strict?
quiet  = app.quiet?

if path?
    unless path[0] in ['/', '~']
        path = __dirname + '/../' + path
    action = (blackList) ->
        blackList.checkPackage path, {strict, quiet}
else if name?
    action = (blackList) ->
        blackList.check name, {strict, quiet}


new BlackList 'http://gulpjs.com/plugins/blackList.json'
    .then (blackList) ->
        action blackList
    .catch (error) ->
        console.error error
