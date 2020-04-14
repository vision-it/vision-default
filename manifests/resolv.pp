# Class: vision_default::resolv
# ===========================
#
# Manage resolv.conf
#

class vision_default::resolv (

  String $domain     = $vision_default::dns_domain,
  Array $nameservers = $vision_default::dns_nameservers,
  Array $searchpath  = $vision_default::dns_search,

) {

  file { '/etc/resolv.conf':
    ensure  => file,
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    content => template('vision_default/resolv.conf.erb'),
  }

}
