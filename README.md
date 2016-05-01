# gulp-blacklisted

[![Build Status](https://travis-ci.org/KamataRyo/gulp-blacklisted.svg?branch=master)](https://travis-ci.org/KamataRyo/gulp-blacklisted)

This checks if blacklisted plugins are included.

## As CLI tool

### examine a project

```
gulp-blacklisted --path=path/to/project/root
```

### examine a specific module

```
gulp-blacklisted --name=gulp-foo
```

### stdout if blacklisted

```
gulp-blacklisted --path=path/to/project/root --strict
```

## As gulp-plugin *under dev*

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
