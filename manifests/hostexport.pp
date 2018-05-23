# Class: vision_default::hostexport
# ===========================
#
# Exports hosts entry for VMs
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::hostexport
#

class vision_default::hostexport (

  String $location                 = $vision_default::location,
  String $fqdn                     = $vision_default::fqdn,
  String $hostname                 = $vision_default::hostname,
  String $ip                       = $vision_default::ip,
  Optional[String] $dom0_hostname  = $vision_default::dom0_hostname,
  Optional[Array] $dns_cnames      = $vision_default::dns_cnames,

) {

  $cnames = flatten([$hostname, $fqdn, $dns_cnames])

  @@host { "${hostname}-vm":
    ensure       => present,
    comment      => "Virtualized Member of ${location}",
    host_aliases => $cnames,
    ip           => $ip,
    tag          => $dom0_hostname,
  }

}
