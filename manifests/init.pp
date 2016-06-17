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

  String $location = $::location,
  String $eth0_ip = $::ipaddress_eth0,
  String $dom0_hostname = $::dom0hostname,

  Array $dns_cnames,
  Array $dns_nameservers,
  Array $dns_search,
  Optional[String] $dns_domain,

  Optional[String] $repo_url = undef,
  String $repo_key,
  String $repo_keyid,

  Hash $default_packages,

) {

  contain ::ruby
  contain ::vision_editors::vim
  contain ::vision_groups::ssl_cert
  contain ::vision_ntp
  contain ::vision_puppet::client
  contain ::vision_rsyslog
  contain ::vision_shells::zsh
  contain ::vision_ssh

  # Files and Directories
  class { 'vision_default::files': }

  # /etc/resolv.conf
  if $location == 'dmz' {
    class { '::resolv_conf':
      nameservers => $dns_nameservers,
      domainname  => $dns_domain,
      searchpath  => $dns_search
    }
  }

  # Packages
  class { 'vision_default::packages':
    packages => $default_packages,
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
