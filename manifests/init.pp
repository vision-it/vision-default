# Class: vision_default
# ===========================
#
# Default profile for all nodes.
# ATTENTION: This manifest is by default applied to all nodes.
#
# Parameters
# ----------
#
# @param hp_repo_keyid Apt Key ID for HP repository
# @param hp_repo_keysource Apt Key Remote Source for HP repository
# @param hp_repo_location Apt Remote Location for HP repository
# @param hosts Content of /etc/hosts
# @param ca_content Content Custom Root CA Certificate
# @param backup_paths List of paths to include in Backup (See Bareos)
# @param default_packages List of packages to install
# @param blacklist_kernel_modules List of Kernel modules to deactivate
# @param monitor_setup List of xrandr settings
#
# @example
# contain ::vision_default
#

class vision_default (

  String $hp_repo_keyid,
  String $hp_repo_keysource,
  String $hp_repo_location,

  Hash   $hosts,
  String $ca_content,
  String $type                     = $::nodetype,
  String $location                 = $::location,
  String $fqdn                     = $::fqdn,
  String $hostname                 = $::hostname,
  String $codename                 = $::lsbdistcodename,
  String $hp_repo_release          = $::lsbdistcodename,
  Optional[String] $ip             = $::ipaddress,
  Optional[String] $manufacturer   = $::manufacturer,

  Optional[String] $dns_domain     = undef,
  Optional[Array] $dns_nameservers = [],
  Optional[Array] $dns_search      = [],

  Optional[Array] $backup_paths    = [],

  Hash $default_packages           = { },
  Hash $blacklist_kernel_modules   = { },
  Hash $monitor_setup              = { },
  Hash $groups                     = { },

  ) {

  # Ensure order of execution
  Class['apt']
  ->Class['vision_default::packages']

  Class['vision_default::zsh']
  ->User['root']

  # Packages
  class { 'vision_default::packages':
    packages => $default_packages,
  }

  contain ::ruby
  contain ::apt
  contain ::unattended_upgrades
  contain ::vision_puppet::masterless
  contain "::vision_default::types::${type}"

  user { 'root':
    ensure         => present,
    home           => '/root',
    purge_ssh_keys => true,
    shell          => '/usr/bin/zsh',
  }

  # Files, directories and facts
  contain vision_default::ssh
  contain vision_default::exim
  contain vision_default::ntp
  contain vision_default::rsyslog
  contain vision_default::files
  contain vision_default::facts
  contain vision_default::ca
  contain vision_default::zsh

  # /etc/resolv.conf
  if $location == 'dmz' {
    contain vision_default::resolv
  }

  # Skipped in development
  if $location != 'vrt' {
    contain ::vision_default::sudo
    resources { 'host':
      purge => true
    }
  }

  host { $fqdn:
    ip           => $ip,
    host_aliases => $hostname,
  }

  create_resources('host', $hosts)
  create_resources('group', $groups)

}
