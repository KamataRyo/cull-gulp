# cull-gulp

[![Build Status](https://travis-ci.org/KamataRyo/cull-gulp.svg?branch=master)](https://travis-ci.org/KamataRyo/cull-gulp)
[![npm version](https://badge.fury.io/js/cull-gulp.svg)](https://badge.fury.io/js/cull-gulp)
![dependencies](https://david-dm.org/KamataRyo/cull-gulp.svg)

This package checks gulpplugins which is marked in [blacklist](http://gulpjs.com/plugins/blackList.json).

## what for?

- simplify your developmental environment.
- save time to select gulpplugins when setting your project up.

## install

### for your project

```
npm install --save-dev cull-gulp
```

### or in global

```
npm install -g cull-gulp
```

## As a CLI tool

### examine a local node project

```
cull-gulp --path=path/to/project/root
```

### without arguments

```
# refer current directory
cull-gulp
```

### examine a specific module name

```
cull-gulp --module=gulp-foo
```

### throw error and exit with 1 if blacklisted

```
cull-gulp --path=path/to/project/root --strict
```

## usage

### with package.json

```
# stop npm test if some plugins are marked as blacklist
{
    scripts: {
        "cull": "./bin/cull-gulp --strict --quiet", # refer current directory without any option
        "pretest": "set -e; npm run cull",
        "test": "# do test here"
    }
}
```

### inside .travis.yml

```
# stop CI if some plugins are marked as blacklist
script:
  - "set -e"
  - "./bin/cull-gulp --strict"
  - "npm test"
```
