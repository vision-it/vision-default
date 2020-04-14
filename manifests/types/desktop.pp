# Class: vision_default::types::desktop
# ===========================
#
# Default profile for all desktop nodes.
#
class vision_default::types::desktop (

  Hash $monitor_setup = $vision_default::monitor_setup,

) {

  # Monitor/Resolution Config
  file { '/usr/local/bin/xrandr.sh':
    ensure  => present,
    content => template('vision_default/xrandr.sh.erb'),
    mode    => '0775',
    owner   => 'root',
    group   => 'vision-it',
  }

}
