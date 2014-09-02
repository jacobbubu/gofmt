gulp        = require 'gulp'
rimraf      = require 'gulp-rimraf'
coffee      = require 'gulp-coffee'
coffeelint  = require 'gulp-coffeelint'
gutil       = require 'gulp-util'

lintOpt =
    no_empty_param_list:
        level: 'error'
    max_line_length:
        level: 'ignore'
    arrow_spacing:
        level: 'error'
    indentation:
        value : 4
        level: 'error'

gulp.task 'lint', ->
    gulp.src 'src/**/*.coffee'
    .pipe coffeelint lintOpt
    .pipe coffeelint.reporter()

gulp.task 'clean', ->
    gulp.src 'lib', { read: false }
    .pipe rimraf()

gulp.task 'compile', ->
    gulp.src 'src/**/*.coffee'
    .pipe coffee bare: true
    .pipe gulp.dest 'lib/'

gulp.task 'default', ['lint', 'clean'], ->
    gulp.start 'compile'