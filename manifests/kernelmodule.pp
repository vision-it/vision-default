# Class: vision_default::kernelmodule
# ===========================
#
# To blacklist kernel modules
#
# Parameters
# ----------
#

define vision_default::kernelmodule (

  $ensure = present,

) {

  package { 'kmod':
    ensure => present
  }

  file { "/etc/modprobe.d/blacklist-${title}.conf":
    ensure  => $ensure,
    content => "blacklist ${title}",
  }

}
