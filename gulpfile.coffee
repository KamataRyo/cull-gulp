gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
meta = require './package.json'

gulp.task 'coffee-app', ->
    gulp.src ['./*.coffee', '!./gulpfile.coffee']
        .pipe coffee bare:false
        .pipe gulp.dest './'

gulp.task 'coffee-spec', ->
    gulp.src ['./spec/*.coffee']
        .pipe coffee bare:false
        .pipe gulp.dest './spec/'

gulp.task 'coffee-bin', ->
    gulp.src ['./bin/*.coffee']
        .pipe coffee bare:false
        .pipe gulp.dest './bin/'


gulp.task 'test', ->
    test = require('./index')({scope: module, quiet:false})

gulp.task 'coffee', ['coffee-app', 'coffee-spec', 'coffee-bin']

gulp.task 'watch', ['coffee'], ->
    gulp.watch [
            './*.coffee', '!./gulpfile.coffee'
            './spec/*.coffee'
            './bin/*.coffee'
        ]
    , ['coffee']
