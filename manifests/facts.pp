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

  $applicationtier = hiera('applicationtier', 'production'),
  $nodetype        = hiera('nodetype', 'server'),

){

  file { '/opt/puppetlabs/facter/facts.d/applicationtier.txt':
    ensure  => present,
    content => "applicationtier=${applicationtier}",
  }

  file { '/opt/puppetlabs/facter/facts.d/nodetype.txt':
    ensure  => present,
    content => "nodetype=${nodetype}",
  }

}
