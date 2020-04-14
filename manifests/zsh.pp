# Class: vision_default::zsh
# ===========================
#
# Manages zsh installation on all nodes
#
class vision_default::zsh {

  if !defined(Package['zsh']) {
    package { 'zsh':
      ensure => present,
    }
  }

  file { '/root/.oh-my-zsh':
    ensure  => directory,
    recurse => remote,
    mode    => '1755',
    source  => 'puppet:///modules/vision_default/oh-my-zsh/',
  }

  file { '/root/.zshrc':
    ensure => present,
    source => 'puppet:///modules/vision_default/zshrc',
  }

}
