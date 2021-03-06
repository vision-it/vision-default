# Define: vision_default::kernelmodule
# ===========================
#
# To blacklist kernel modules
#
define vision_default::kernelmodule (

  $ensure = present,

) {

  file { "/etc/modprobe.d/blacklist-${title}.conf":
    ensure  => $ensure,
    content => "blacklist ${title}",
  }

}
