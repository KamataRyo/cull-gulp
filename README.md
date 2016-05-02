# cull-gulp

[![Build Status](https://travis-ci.org/KamataRyo/cull-gulp.svg?branch=master)](https://travis-ci.org/KamataRyo/cull-gulp)

This package checks blacklisted gulpplugins.
This is not gulp plugin.

## As a CLI tool

### examine a local node project

```
cull-gulp --path=path/to/project/root
```

### examine a specific module name

```
cull-gulp --name=gulp-foo
```

### throw error to stderr if blacklisted

```
cull-gulp --path=path/to/project/root --strict
```

## Inside gulpfile.js

```
require('cull-gulp')({strict:true});// throw error and stop  if blacklisted plugin are required.
```

## what for?

- simplify your developmental environment.
- save time to select gulp-plugin.
