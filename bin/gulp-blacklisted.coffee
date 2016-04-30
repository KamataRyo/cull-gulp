`#!/usr/bin/env node
`

app  = require 'commander'
lib  = require '../lib'
meta = require '../package.json'

app
    .version meta.version

app
    .option '-p, --path <path>', 'Set path to project root to check.'
    .option '-n, --name <name>', 'Set typical npm name to check.'
    .option '-s, --strict', 'raise error if blacklisted'
    .parse process.argv

path = app.path
name = app.name
strict = app.strict?

if path?
    lib.check {path, strict}, (error, result) ->
        if result.isBlacklisted
            console.log 'blacklisted'
        else
            console.log 'not blacklisted'
