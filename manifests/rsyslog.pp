# Class: vision_default::rsyslog
# =====================
#
# Manage rsyslog installation and config
#
# Parameters
# ----------
#
# @param puppet_log_file Path to Puppet log file
#

class vision_default::rsyslog (

  String $puppet_log_file = '/var/log/puppetlabs/puppet/agent.log',

) {

  package { 'rsyslog':
    ensure => installed,
  }

  service { 'rsyslog':
    hasrestart => true,
    require    => Package['rsyslog'],
  }

  file { '/etc/rsyslog.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('vision_default/rsyslog.conf'),
    notify  => Service['rsyslog'],
  }

  # Additional Rules Directory
  file { '/etc/rsyslog.d/firewall.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('vision_default/rsyslog.firewall.conf'),
    notify  => Service['rsyslog'],
  }

  file { '/etc/rsyslog.d/puppet.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "local6.* ${puppet_log_file}",
    notify  => Service['rsyslog'],
  }

}
