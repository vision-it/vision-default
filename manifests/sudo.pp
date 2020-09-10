# Class: vision_default::sudo
# ===========================
#
# Install and configure sudo

class vision_default::sudo {

  package { 'sudo':
    ensure => present,
  }

  file { 'Purge sudoers.d':
    ensure  => directory,
    path    => '/etc/sudoers.d/',
    purge   => true,
    recurse => true,
    mode    => '0440',
    source  => 'puppet:///modules/vision_default/sudoers.d/',
    require => Package['sudo']
  }
}
