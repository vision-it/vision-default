# Class: vision_default::types::server
# ===========================
#
# Default profile for all server nodes.
#
# Parameters
# ----------
#
# @param blacklist_kernel_modules Kernel modules to blacklist
#
class vision_default::types::server (

  Hash $blacklist_kernel_modules = $vision_default::blacklist_kernel_modules,

) {

  contain ::vision_apt::unattended_upgrades
  contain ::vision_exim
  contain ::vision_logcheck
  contain ::vision_pki

  # Install SMART tests on all non-VMs (physical servers)
  if ($::vision_default::location !~ '(?i:Vm|vrt)$') {
    contain ::vision_smart
  }

  create_resources('vision_default::kernelmodule', $blacklist_kernel_modules)

}
