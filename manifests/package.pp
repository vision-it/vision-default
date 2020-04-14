# Define: vision_default::package
# ===========================
#
# Parameters
# ----------
#
# @param provider Installation Provider (apt, gem, etc.)
# @param ensure Status of Package
#
define vision_default::package (

  $provider = apt,
  $ensure   = present,

) {

  if !defined(Package[ $title ]) {
    package { $title:
      ensure   => $ensure,
      provider => $provider,
    }
  }

}
