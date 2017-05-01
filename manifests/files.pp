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

  Array $backup_paths = $vision_default::backup_paths,

){

  file { '/root/.ssh':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0700',
  }

  file { '/vision':
    ensure => directory,
  }

  file { '/vision/backup-fileset':
    ensure  => present,
    content => template('vision_default/backup-fileset.erb'),
    require => File['/vision'],
  }

  file { '/opt':
    ensure => directory,
  }

}
