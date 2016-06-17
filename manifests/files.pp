# Class: vision_default::files
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::files
#

class vision_default::files (
){

  user { 'root':
    ensure         => present,
    home           => '/root',
    purge_ssh_keys => true,
    require        => Package['zsh'],
  }

  file { '/root/.ssh':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0700',
  }

  file { '/vision':
    ensure => directory,
  }

  file { '/opt':
    ensure => directory,
  }


}
