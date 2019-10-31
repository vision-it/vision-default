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

  String $location   = $vision_default::location,
  String $ca_content = $vision_default::ca_content,

) {

  if $location != 'vrt' {

    file { '/usr/local/share/ca-certificates/VisionCA.crt':
      ensure  => present,
      content => $ca_content,
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
