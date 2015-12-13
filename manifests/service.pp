# == Class: rngd::service
#
class rngd::service inherits rngd {

  if ! ($rngd::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $rngd::service_manage == true {
    service { 'rngd':
      ensure     => $rngd::service_ensure,
      enable     => $rngd::service_enable,
      name       => $rngd::service_name,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}