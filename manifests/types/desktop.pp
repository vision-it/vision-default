# desktop specific
class vision_default::types::desktop () {
  # Monitor/Resolution Config
  file { '/usr/local/bin/xrandr.sh':
    ensure  => present,
    content => file('vision_default/xrandr.sh'),
    mode    => '0775',
    owner   => 'root',
    group   => 'vision-it',
  }

}
