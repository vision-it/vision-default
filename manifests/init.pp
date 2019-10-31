# Class: vision_default
# ===========================
#
# Default profile for all nodes.
# ATTENTION: This manifest is by default applied to all nodes.
#
# Parameters
# ----------
#
# Examples
# --------
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
  String $hp_repo_release          = "${codename}/current",
  Optional[String] $ip             = $::ipaddress,
  Optional[String] $manufacturer   = $::manufacturer,

  Optional[String] $dns_domain     = undef,
  Optional[Array] $dns_nameservers = [],
  Optional[Array] $dns_search      = [],

  Optional[Array] $backup_paths    = [],

  Hash $default_packages           = { },
  Hash $sysctl_entries             = { },
  Hash $blacklist_kernel_modules   = { },
  Hash $monitor_setup              = { },

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
  contain ::vision_groups
  contain ::vision_ntp
  contain ::vision_rsyslog
  contain ::vision_ssh
  contain ::vision_sudo
  contain ::vision_puppet::masterless
  contain ::unattended_upgrades

  contain "::vision_default::types::${type}"

  user { 'root':
    ensure         => present,
    home           => '/root',
    purge_ssh_keys => true,
    shell          => '/usr/bin/zsh',
  }

  # Files, directories and facts
  contain vision_default::files
  contain vision_default::facts
  contain vision_default::ca
  contain vision_default::zsh

  # /etc/resolv.conf
  if $location == 'dmz' {
    contain vision_default::resolv
  }

  # Hostsfile
  if $location != 'vrt' {
    resources { 'host':
      purge => true
    }
  }

  host { $fqdn:
    ip           => $ip,
    host_aliases => $hostname,
  }

  create_resources('host', $hosts)

  # Sysctl
  $sysctl_defaults = {
    'ensure' => present,
  }

  create_resources(sysctl, $sysctl_entries, $sysctl_defaults)

}
