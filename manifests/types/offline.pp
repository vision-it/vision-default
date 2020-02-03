# Class: vision_default::types::offline
# ===========================
#
# Default profile for all offline nodes that are temporarily online.
#
# Parameters
# ----------
#
# @param blacklist_kernel_modules Kernel modules to blacklist
#
class vision_default::types::offline (

  Hash $blacklist_kernel_modules = $vision_default::blacklist_kernel_modules,

) {

  contain ::vision_exim

  class { '::vision_firewall':
    require => Class['vision_default::facts'],
  }

  create_resources('vision_default::kernelmodule', $blacklist_kernel_modules)

  # Smartctl
  contain ::vision_smart

}
