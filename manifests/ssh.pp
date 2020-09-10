# Class: vision_default::ssh
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::ssh
#

class vision_default::ssh (

  Hash $authorized_keys,
  String $server_description = 'Change me',
  Hash $ssh_options = {},

) {

  file { '/etc/motd':
    ensure  => present,
    owner   => root,
    content => template('vision_default/ssh/motd.erb'),
  }

  $key_defaults = {
    'ensure' => absent,
    'user'   => root,
  }
  create_resources('ssh_authorized_key', $authorized_keys, $key_defaults)

  class { '::ssh::client':
    storeconfigs_enabled => false,
    options              => $ssh_options,
  }

  class { '::ssh::server':
    storeconfigs_enabled => false,
    options              => {
      'X11Forwarding'          => 'no',
      'PrintMotd'              => 'yes',
      'Banner'                 => 'no',
      'IgnoreRhosts'           => 'yes',
      'PrintLastLog'           => 'yes',
      'PermitRootLogin'        => 'yes',
      'Port'                   => '22',
      'UsePrivilegeSeparation' => 'yes',
      'PasswordAuthentication' => 'no',
      'PubkeyAuthentication'   => 'yes',
      'Protocol'               => '2',
      'StrictModes'            => 'yes',
      'UsePAM'                 => 'no',
      'SyslogFacility'         => 'AUTH',
      'LogLevel'               => 'INFO',
    }
  }
}
