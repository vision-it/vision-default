# vision-default

[![Build Status](https://travis-ci.org/vision-it/vision-default.svg?branch=production)](https://travis-ci.org/vision-it/vision-default)

This profile is included in **all** machines which manages:
  * Default Packages
  * Groups
  * Ntp
  * Puppet Client
  * Rsyslog
  * Ruby
  * Ssh
  * Sysctl
  * Vim
  * VisionCa
  * Zsh

Then it applies server/desktop specific code.

For **servers** this includes:
  * Exim
  * Logcheck
  * Munin
  * Nagios
  * Smart on physical servers
  * Unattended upgrades

For **desktops** this includes:
  * Xrandr for x11 screen resolutions

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

