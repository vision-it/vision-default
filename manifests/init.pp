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
  String $dom0_hostname = $::dom0hostname,

  Optional[String] $dns_domain,
  Array $dns_cnames,
  Array $dns_nameservers,
  Array $dns_search,

  Optional[String] $repo_url = undef,
  Optional[String] $repo_key,
  Optional[String] $repo_keyid,

  Hash $default_packages,

) {

  contain ::ruby
  contain ::vision_editors::vim
  contain ::vision_groups
  contain ::vision_ntp
  contain ::vision_puppet::client
  contain ::vision_rsyslog
  contain ::vision_shells::zsh
  contain ::vision_ssh


  if $type == 'server' {

    contain ::vision_apt::unattended_upgrades
    contain ::vision_pki
    contain ::vision_logcheck
    contain ::vision_exim
    #contain ::vision_munin

    # Install SMART tests on all non-VMs (physical servers)
    if ($location !~ '(?i:Vm)$') {
      contain ::vision_smart
    }
  }


  if $type == 'desktop' {

    # Monitor/Resolution Config
    file { '/usr/local/bin/xrandr.sh':
      ensure => present,
      source => 'puppet:///modules/vision_default/xrandr.sh',
      mode   => '0775',
      owner  => 'root',
      group  => 'vision-it',

    }
  }


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
