# Class: vision_default::facts
# ===========================
#
# Manage Facter custom facts
#
# @example
# contain ::vision_default::facts
#

class vision_default::facts (

  String $type = lookup('nodetype', String, 'first','server'),

){

  file { '/opt/puppetlabs/facter/facts.d/nodetype.txt':
    ensure  => present,
    content => "nodetype=${type}",
  }

}
