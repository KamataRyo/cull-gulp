# gulp-blacklisted

This is under development.

## specs

### As CLI tool

```
# examine the project's package.json
$ gulp-blacklisted /path/to/the/project
# examine certine npm if `gulp-xxx` blacklisted
$ gulp-blacklisted gulp-xxx
```

### As gulp-plugin

```
#check if required module blacklisted
foo         = require 'gulp-foo' // blacklisted
bar         = require 'gulp-bar'
blacklisted = require 'gulp-blacklisted'

gulp.task 'task', ->
    gulp.src 'src'
        .pipe blacklisted strict:false // do nothing in the stream
        .pipe foo()
        .pipe bar()
        .pipe dest 'dest'

// task above notice like below;
// [notice] module 'gulp-foo' is gulp-blacklisted.
// or on strict mode (strict:true)
// [error] module 'gulp-foo' is gulp-blacklisted.
```

### usage
#### for developmental environment purification

Save time to select gulp-plugins.
