# cull-gulp

[![Build Status](https://travis-ci.org/KamataRyo/cull-gulp.svg?branch=master)](https://travis-ci.org/KamataRyo/cull-gulp)

This package checks gulpplugins which is marked in [blacklist](http://gulpjs.com/plugins/blackList.json).

## what for?

- simplify your developmental environment.
- save time to select gulp-plugin when setting your project up.

## install

### for your project

```
npm install --save-dev cull-gulp
```

### or global

```
npm install -g cull-gulp
```

## As a CLI tool

### examine a local node project

```
cull-gulp --path=path/to/project/root
```

### examine a specific module name

```
cull-gulp --name=gulp-foo
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
        "cull": "./bin/cull-gulp --strict --quiet",
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
