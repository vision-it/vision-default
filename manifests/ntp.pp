# Class: vision_default::ntp
# ===========================
#
# Parameters
# ----------
#
# @param servers List of NTP servers
# @param restrictions Restrictions on our network
# @param driftfile Path to dift file
#
# Examples
# --------
#
# @example
# contain ::vision_default::ntp
#

class vision_default::ntp (

  Array[String] $servers,
  Array[String] $restrictions,

) {

  class { '::ntp':
    driftfile     => '/var/lib/ntp/ntp.drift',
    iburst_enable => true,
    restrict      => $restrictions,
    servers       => $servers,
  }

}
