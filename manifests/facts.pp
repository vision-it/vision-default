# Class: vision_default::facts
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::facts
#

class vision_default::facts (

  String $tier                  = hiera('applicationtier', 'production'),
  String $type                  = hiera('nodetype', 'server'),
  Optional[String] $backup_port = $vision_default::backup_port,
  String $location              = $vision_default::location,

){

  file { '/opt/puppetlabs/facter/facts.d/applicationtier.txt':
    ensure  => present,
    content => "applicationtier=${tier}",
  }

  file { '/opt/puppetlabs/facter/facts.d/nodetype.txt':
    ensure  => present,
    content => "nodetype=${type}",
  }

  # Set backup_port or calculate it only in VMs
  if $location =~ /(dmz|int)Vm/ {

    if $backup_port == undef {

      $ip_array         = split($::ipaddress, '\.')
      $ip_last_triple   = $ip_array[-1]
      $calc_backup_port = "23${ip_last_triple}"

      file { '/opt/puppetlabs/facter/facts.d/backup_port.txt':
        ensure  => present,
        content => "backup_port=${calc_backup_port}",
      }
    }

    else {

      file { '/opt/puppetlabs/facter/facts.d/backup_port.txt':
        ensure  => present,
        content => "backup_port=${backup_port}",
        }
    }
  }

}
