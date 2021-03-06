# Class: vision_default::packages
# ===========================
#
# Creates Resources for all packages

class vision_default::packages (

  Hash $packages,

) {

  $package_default = {
    ensure   => present,
    provider => apt,
  }

  create_resources('package', $packages, $package_default)

}
