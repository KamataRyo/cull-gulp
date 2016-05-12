app      = require 'commander'
CullGulp = require '../CullGulp'
meta     = require '../package.json'

app
    .version require('../package.json').version
    .option '-p --path <path>', 'Set path to project root directory'
    .option '-m --module <module>', 'Set typical npm module name to check'
    .option '-s --strict', 'raise error if black-listed'
    .option '-q --quiet', 'show whether black-listed to stdout.'
    .parse process.argv

path = app.path
name = app.module
strict = app.strict?
quiet = app.quiet?

if path?
    unless path[0] in ['/', '~']
        path = process.cwd() + '/' + path
        console.log path
    action = (cullGulp) ->
        cullGulp.checkPackage path, {strict, quiet}
else if name?
    action = (cullGulp) ->
        cullGulp.check name, {strict, quiet, throwError: strict}
else
    path = process.cwd()
    action = (cullGulp) ->
        cullGulp.checkPackage path, {strict, quiet}


new CullGulp meta.config.blackListURL
    .then (cullGulp) ->
        action cullGulp
    .catch (error) ->
        console.error error
        process.exit 1
