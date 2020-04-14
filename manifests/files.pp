# Class: vision_default::files
# ===========================
#
# Manage basic files and directories
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

  # for application data storaged, backed up, replicated
  file { '/vision/data':
    ensure  => directory,
    require => File['/vision'],
  }

  # for application configuration, not backed up, replicated
  file { '/vision/etc':
    ensure  => directory,
    require => File['/vision'],
  }

  file { '/opt':
    ensure => directory,
  }

}
