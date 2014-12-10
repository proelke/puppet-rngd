class rngd  (
  $config            = $rngd::params::config,
  $config_template   = $rngd::params::config_template,
  $extra_options     = $rngd::params::extra_options,
  $package_ensure    = $rngd::params::package_ensure,
  $package_name      = $rngd::params::package_name,
  $service_enable    = $rngd::params::service_enable,
  $service_ensure    = $rngd::params::service_ensure,
  $service_manage    = $rngd::params::service_manage,
  $service_name      = $rngd::params::service_name,
) inherits rngd::params {
  
  validate_absolute_path($config)
  validate_string($config_template)
  validate_string($extra_options)
  validate_string($package_ensure)
  validate_array($package_name)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_string($service_name)

  anchor { 'rngd::begin': } ->
  class { '::rngd::install': } ->
  class { '::rngd::config': } ~>
  class { '::rngd::service': } ->
  anchor { 'rngd::end': }

}
