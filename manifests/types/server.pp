# server specific
class vision_default::types::server () {
  contain ::vision_apt::unattended_upgrades
  contain ::vision_pki
  contain ::vision_logcheck
  contain ::vision_exim
  # tmp disabled; reenable after apache prd release
  #contain ::vision_munin

  # Install SMART tests on all non-VMs (physical servers)
  if ($::vision_default::location !~ '(?i:Vm|vrt)$') {
    contain ::vision_smart
  }
}
