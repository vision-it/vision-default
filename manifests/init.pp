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
  String $hp_repo_release,

  String $type                     = $::nodetype,
  String $location                 = $::location,
  String $manufacturer             = $::manufacturer,
  String $eth0_ip                  = $::ipaddress_eth0,
  Optional[String] $dom0_hostname  = $::dom0hostname,
  Optional[String] $backup_port    = undef,

  Optional[String] $dns_domain     = undef,
  Optional[Array] $dns_cnames      = [],
  Optional[Array] $dns_nameservers = [],
  Optional[Array] $dns_search      = [],

  Hash $default_packages           = { },
  Hash $sysctl_entries             = { },
  Hash $blacklist_kernel_modules   = { },

) {

  # Packages
  class { 'vision_default::packages':
    packages => $default_packages,
  }

  contain ::ruby
  contain ::apt
  contain ::vision_groups
  contain ::vision_ntp
  contain ::vision_puppet::client
  contain ::vision_rsyslog
  contain ::vision_ssh
  contain ::vision_sudo
  contain ::vision_apt::unattended_upgrades

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

  # Exported Resource
  if $location =~ /(dmz|int)Vm/ {

    $cnames = flatten([$::hostname, $dns_cnames])

    @@host { $::fqdn:
      ensure       => present,
      comment      => "Virtualized Member of ${location}",
      host_aliases => $cnames,
      ip           => $eth0_ip,
      tag          => $dom0_hostname,
    }
  }

  # Sysctl
  $sysctl_defaults = {
    'ensure' => present,
  }

  create_resources(sysctl, $sysctl_entries, $sysctl_defaults)

}
