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

  # the user is exported, and later collected via the ohmyzsh module
  # this is not the best solution but preventing a duplicate resource
  # declaration
  @@user { 'root':
    ensure         => present,
    home           => '/root',
    purge_ssh_keys => true,
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
