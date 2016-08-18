# vision-default

[![Build Status](https://travis-ci.org/vision-it/vision-default.svg?branch=production)](https://travis-ci.org/vision-it/vision-default)

## Parameters

### Default Packages
Packages which should be installed on **every** node can be added to the
[common.yaml](data/common.yaml).

```yaml
vision_default::default_packages:
  zsh:
    ensure: present
  tcpdump:
    ensure: absent
```

## Installation

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

