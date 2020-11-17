# Class: vision_default::types::server
# ===========================
#
# Default profile for all server nodes.
#

class vision_default::types::server (

  Hash $blacklist_kernel_modules = $vision_default::blacklist_kernel_modules,
  String $location               = $vision_default::location,
  String $hp_repo_keyid          = $vision_default::hp_repo_keyid,
  String $hp_repo_keysource      = $vision_default::hp_repo_keysource,
  String $hp_repo_location       = $vision_default::hp_repo_location,
  String $hp_repo_release        = $vision_default::hp_repo_release,
  Optional[String] $manufacturer = $vision_default::manufacturer,

) {

  contain ::vision_logrotate

  class { '::vision_firewall':
    require => Class['vision_default::facts'],
  }

  create_resources('vision_default::kernelmodule', $blacklist_kernel_modules)

  # Physical Servers only
  if ($location !~ '(?i:Vm|vrt)$') {

    # Smartctl
    contain ::vision_smart

    if ($manufacturer == 'HP') {

      # HP Repository
      apt::key { 'hpe.com':
        id     => $hp_repo_keyid,
        source => $hp_repo_keysource,
      }
      -> apt::source { 'hpe':
        location => $hp_repo_location,
        key      => $hp_repo_keyid,
        release  => "${hp_repo_release}/current",
        repos    => 'non-free',
      }
      -> package { 'ssacli':
        ensure  => 'present',
        require => Apt::Source['hpe'],
      }

    }

  }

}
