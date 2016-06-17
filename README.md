# vision-default

[![Build Status](https://travis-ci.org/vision-it/vision-default.svg?branch=production)](https://travis-ci.org/vision-it/vision-default)

## Parameter


## Usage

Include in the *Puppetfile*:

```
mod vision_default:
    :git => 'https://github.com/vision-it/vision-default.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_default
```

