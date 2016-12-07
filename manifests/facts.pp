# Class: vision_default::facts
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::facts
#

class vision_default::facts (

  $tier = hiera('applicationtier', 'production'),
  $type = hiera('nodetype', 'server'),

){

  file { '/opt/puppetlabs/facter/facts.d/applicationtier.txt':
    ensure  => present,
    content => "applicationtier=${tier}",
  }

  file { '/opt/puppetlabs/facter/facts.d/nodetype.txt':
    ensure  => present,
    content => "nodetype=${type}",
  }

}
