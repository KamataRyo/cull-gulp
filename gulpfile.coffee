gulp    = require 'gulp'
plumber = require 'gulp-plumber'
coffee  = require 'gulp-coffee'
rename  = require 'gulp-rename'
chmod   = require 'gulp-chmod'

gulp.task 'coffee-app', ->
    gulp.src ['./*.coffee', '!./gulpfile.coffee']
        .pipe plumber()
        .pipe coffee bare:false
        .pipe gulp.dest './'

gulp.task 'coffee-spec', ->
    gulp.src ['./spec/*.coffee']
        .pipe plumber()
        .pipe coffee bare:false
        .pipe gulp.dest './spec/'

gulp.task 'coffee-bin', ->
    gulp.src './bin/*.coffee'
        .pipe plumber()
        .pipe coffee bare:true
        .pipe rename (path) ->
            path.extname = ''
        .pipe chmod 755
        .pipe gulp.dest './bin/'

gulp.task 'coffee', ['coffee-app', 'coffee-spec', 'coffee-bin']


blacklisted = require './index'

gulp.task 'test-plugin', ->
    gulp.src './gulpfile.coffee'
        .pipe coffee()
        .pipe blacklisted {scope: 'project', quiet:false}
