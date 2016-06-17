# Class: vision_default::repository
# ===========================
#
# Add Vision apt repository to the sources.list.d
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_default::repository
#

class vision_default::repository (

  String $repo_key,
  String $repo_keyid,
  String $repo_url,
  String $release = $::facts[lsbdistcodename],

) {

  apt::source { 'vision-repo':
    location => $repo_url,
    release  => $release,
    repos    => 'main',
  }

  apt::key { 'vision-repo':
    ensure      => present,
    id          => $repo_keyid,
    key_content => $repo_key,
  }

}
