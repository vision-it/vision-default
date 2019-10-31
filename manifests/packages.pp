# Class: vision_default::packages
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::packages
#

class vision_default::packages (

  Hash $packages,

) {

$package_default = {
    ensure   => present,
    provider => apt,
  }

  create_resources('vision_default::package', $packages, $package_default)

}
