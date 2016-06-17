# Class: vision_default::package
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::package
#

define vision_default::package (
  $provider = apt,
  $ensure = present,
) {

  package { $title:
    ensure   => $ensure,
    provider => $provider
  }

}
