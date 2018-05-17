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
  String $type                     = $::nodetype,
  String $location                 = $::location,
  String $fqdn                     = $::fqdn,
  String $hostname                 = $::hostname,
  String $codename                 = $::lsbdistcodename,
  String $hp_repo_release          = "${codename}/current",
  Optional[String] $ip             = $::ipaddress,
  Optional[String] $manufacturer   = $::manufacturer,
  Optional[String] $dom0_hostname  = $::dom0hostname,
  Optional[String] $backup_port    = undef,
  Optional[String] $ssh_port       = undef,

  Optional[String] $dns_domain     = undef,
  Optional[Array] $dns_cnames      = [],
  Optional[Array] $dns_nameservers = [],
  Optional[Array] $dns_search      = [],

  Optional[Array] $backup_paths    = [],

  Boolean $masterless              = false,

  Hash $default_packages           = { },
  Hash $sysctl_entries             = { },
  Hash $blacklist_kernel_modules   = { },
  Hash $monitor_setup              = { },

) {

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
  contain ::unattended_upgrades

  if $masterless {
    contain ::vision_puppet::masterless
  } else {
    contain ::vision_puppet::client
  }

  contain "::vision_default::types::${type}"

  # the user is virtualized, and later realized via the ohmyzsh module
  # this is not the best solution but preventing a duplicate resource
  # declaration and it's allowing us to
  @user { 'root':
    ensure         => present,
    home           => '/root',
    purge_ssh_keys => true,
  }

  # Files, directories and facts
  contain vision_default::files
  contain vision_default::facts
  contain vision_default::ca

  Package['zsh'] -> User['root']

  class { '::vision_shells::zsh':
    require => Class['vision_default::packages'],
  }

  # /etc/resolv.conf
  if $location == 'dmz' {
    class { '::resolv_conf':
      nameservers => $dns_nameservers,
      domainname  => $dns_domain,
      searchpath  => $dns_search
    }
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

  if $location =~ /(dmz|int)Vm/ {
    contain vision_default::hostexport
  }

  # Sysctl
  $sysctl_defaults = {
    'ensure' => present,
  }

  create_resources(sysctl, $sysctl_entries, $sysctl_defaults)

}
