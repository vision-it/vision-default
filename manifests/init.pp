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

  String $type = $::nodetype,
  String $location = $::location,
  String $eth0_ip = $::ipaddress_eth0,
  Optional[String] $dom0_hostname = $::dom0hostname,

  Optional[String] $dns_domain = undef,
  Optional[Array] $dns_cnames = undef,
  Optional[Array] $dns_nameservers = undef,
  Optional[Array] $dns_search = undef,

  Optional[String] $repo_url = undef,
  Optional[String] $repo_key,
  Optional[String] $repo_keyid,

  Hash $default_packages = {},

) {

  # Packages
  class { 'vision_default::packages':
    packages => $default_packages,
  }

  contain ::ruby
  contain ::vision_editors::vim
  contain ::vision_groups
  contain ::vision_ntp
  contain ::vision_puppet::client
  contain ::vision_rsyslog
  contain ::vision_ssh

  contain "::vision_default::types::${type}"

  # the user is virtualized, and later realized via the ohmyzsh module
  # this is not the best solution but preventing a duplicate resource
  # declaration and it's allowing us to
  @user { 'root':
    ensure         => present,
    home           => '/root',
    purge_ssh_keys => true,
  }
  # Files and Directories
  contain vision_default::files

  class {'::vision_shells::zsh':
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




  # Repository
  if $repo_url {
    class { 'vision_default::repository':
      repo_key   => $repo_key,
      repo_keyid => $repo_keyid,
      repo_url   => $repo_url,
    }
  }


  # CA
  class { 'vision_default::ca':
    location => $location,
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

}
