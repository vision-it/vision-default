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
  String $eth0_ip                  = $vision_default::ipaddress_eth0,
  Optional[String] $dom0_hostname  = $vision_default::dom0_hostname,
  Optional[Array] $dns_cnames      = $vision_default::dns_cnames,

) {

  if $location =~ /(dmz|int)Vm/ {

    $cnames = flatten([$hostname, $fqdn, $dns_cnames])

    @@host { "${hostname}-vm":
      ensure       => present,
      comment      => "Virtualized Member of ${location}",
      host_aliases => $cnames,
      ip           => $eth0_ip,
      tag          => $dom0_hostname,
    }

  }

}
