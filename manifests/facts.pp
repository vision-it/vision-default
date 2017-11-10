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

  String $type                  = lookup('nodetype', String, 'first','server'),
  Optional[String] $backup_port = $vision_default::backup_port,
  String $location              = $vision_default::location,

){

  file { '/opt/puppetlabs/facter/facts.d/nodetype.txt':
    ensure  => present,
    content => "nodetype=${type}",
  }

  # Set backup_port or calculate it only in VMs
  if $location =~ /(dmz|int)Vm/ {

    if $backup_port == undef {

      $ip_array         = split($::ipaddress, '\.')
      $calc_backup_port = sprintf('23%02d', $ip_array[-1])

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
