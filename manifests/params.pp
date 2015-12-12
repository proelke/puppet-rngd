# == Class: rngd::params
#
class rngd::params {

  $config_template   = 'rngd/rngd.erb'
  $extra_options     = ''
  $package_ensure    = 'present'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true

  $default_config       = '/etc/sysconfig/rngd'
  $default_package_name = ['rng-tools']
  $default_service_name = 'rngd'

  case $::osfamily {
    'RedHat': {
      $config          = $default_config
      $package_name    = $default_package_name
      $service_name    = $default_service_name
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}