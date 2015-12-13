# == Class: rngd
#
class rngd (
  $config          = 'USE_DEFAULTS',
  $config_template = 'rngd/rngd.erb',
  $extra_options   = '',
  $package_ensure  = 'present',
  $package_name    = 'USE_DEFAULTS',
  $service_enable  = true,
  $service_ensure  = 'running',
  $service_manage  = true,
  $service_name    = 'USE_DEFAULTS',
) {

  case $::osfamily {
    'RedHat': {
      $config_default       = '/etc/sysconfig/rngd'
      $package_name_default = ['rng-tools']
      $service_name_default = 'rngd'
    }
    default: {
      fail("The rngd module is not supported on an ${::osfamily} based system.")
    }
  }

  if $config == 'USE_DEFAULTS' {
    $config_real = $config_default
  } else {
    $config_real = $config
  }

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real = $package_name_default
  } else {
    $package_name_real = $package_name
  }

  if $service_name == 'USE_DEFAULTS' {
    $service_name_real = $service_name_default
  } else {
    $service_name_real = $service_name
  }

  validate_absolute_path($config_real)
  validate_string($config_template)
  validate_string($extra_options)
  validate_string($package_ensure)
  validate_array($package_name_real)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name_real)

  if ! ($rngd::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  package { $rngd::package_name_real:
    ensure => $rngd::package_ensure,
  }

  file { $rngd::config_real:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($rngd::config_template),
    require => Package[$rngd::package_name_real],
  }

  if $rngd::service_manage == true {
    service { 'rngd':
      ensure     => $rngd::service_ensure,
      enable     => $rngd::service_enable,
      name       => $rngd::service_name,
      hasstatus  => true,
      hasrestart => true,
      require    => File[$rngd::config_real],
      subscribe  => File[$rngd::config_real],
    }
  }
}
