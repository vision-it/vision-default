# Class: vision_default::ca
# ===========================
#
# Install the Vision CA
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::ca
#

class vision_default::ca (

  String $location = $vision_default::location,

) {

  if $location != 'vrt' {

    file { '/usr/local/share/ca-certificates/VisionCA.crt':
      ensure => present,
      source => 'puppet:///modules/vision_default/VisionCA.crt',

    }

    exec { 'update-ca-certificates-Vision-crt':
      command     => '/usr/sbin/update-ca-certificates',
      refreshonly => true,
      subscribe   => File['/usr/local/share/ca-certificates/VisionCA.crt'],
    }

    } else {

      file { '/usr/local/share/ca-certificates/VisionCA.crt':
        ensure => present,
      }

    }

}
