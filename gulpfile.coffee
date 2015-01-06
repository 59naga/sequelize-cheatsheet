files= '*.coffee'
specs= '*.spec.coffee'

gulp= require 'gulp'
jasmine= require 'gulp-jasmine'

gulp.task 'default',['jasmine'],->
  gulp.watch files,['jasmine']
gulp.task 'jasmine',->
  gulp.src specs
    .pipe jasmine
      verbose:true
