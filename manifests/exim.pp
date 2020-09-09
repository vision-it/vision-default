# Class: vision_default::exim
# ===========================
#
# Parameters
# ----------
#
# @param mailserver Which mailserver to use
# @param catch_all_alias Name for catch all alias
# @param catch_all_email Alias for all mails
#

class vision_default::exim (

  String $mailserver,
  String $catch_all_email,

) {

  service { 'exim4':
    ensure => running,
  }

  file { '/etc/exim4/conf.d/router/160_exim4-config_vision':
    ensure  => present,
    content => template('vision_default/exim-smarthost.erb'),
    notify  => Service['exim4'],
  }

  # /etc/exim4/update.conf
  # The file is actually 'update-exim4.conf.conf'... I know right?!
  file { '/etc/exim4/update-exim4.conf.conf':
    ensure  => present,
    content => template('vision_default/exim-satellite.erb'),
    notify  => Service['exim4'],
  }

  # /etc/aliases
  mailalias { 'vision-it':
    ensure    => present,
    name      => root,
    target    => '/etc/aliases',
    recipient => $catch_all_email,
  }

  # /etc/mailname
  file { '/etc/mailname':
    ensure  => present,
    content => $::fqdn,
  }

}
