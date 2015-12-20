# == Class: rngd
#
class rngd (
  $config_file     = 'USE_DEFAULTS',
  $config_template = 'rngd/rngd.erb',
  $extra_options   = undef,
  $package_ensure  = 'present',
  $package_name    = 'USE_DEFAULTS',
  $service_enable  = true,
  $service_ensure  = 'running',
  $service_manage  = true,
  $service_name    = 'USE_DEFAULTS',
) {

  # osfamily deviation handling
  case $::osfamily {
    'RedHat': {
      $config_file_default  = '/etc/sysconfig/rngd'
      $package_name_default = ['rng-tools']
      $service_name_default = 'rngd'
    }
    default: {
      fail("The rngd module is not supported on an ${::osfamily} based system.")
    }
  }

  if $config_file == 'USE_DEFAULTS' {
    $config_file_real = $config_file_default
  } else {
    $config_file_real = $config_file
  }

  if $package_name == 'USE_DEFAULTS' {
    $package_name_array = $package_name_default
  } else {
    # convert $package_name to array to allow using a string
    case type3x($package_name) {
      'array': {
        $package_name_array = $package_name
      }
      'string': {
        $package_name_array = any2array($package_name)
      }
      default: {
        fail('cron::package_name is not a string nor an array.')
      }
    }
  }

  if $service_name == 'USE_DEFAULTS' {
    $service_name_real = $service_name_default
  } else {
    $service_name_real = $service_name
  }
  # /osfamily specifics handling

  # convert input variable types
  $service_ensure_string = "${service_ensure}" # lint:ignore:only_variable_string
  $service_enable_string = "${service_enable}" # lint:ignore:only_variable_string

  if is_bool($service_manage) == true {
    $service_manage_bool = $service_manage
  } else {
    $service_manage_bool = str2bool($service_manage)
  }
  # /convert input variable types

  # validate variable content
  validate_absolute_path($config_file_real)
  validate_array($package_name_array)
  validate_bool($service_manage_bool)
  validate_string($config_template)
  validate_string($service_name_real)
  if $extra_options != undef {
    validate_string($extra_options)
  }
  validate_re($package_ensure, '^(present|installed|absent|latest)$',
    'rngd::service_ensure must be present, installed, absent or latest.')
  validate_re($service_enable_string, '^(true|false|manual|mask)$',
    'rngd::service_ensure must be true, false, manual or mask.')
  validate_re($service_ensure_string, '^(running|stopped|true|false)$',
    'rngd::service_ensure must be running, stopped, true or false.')
  # /validate variable content

  # configure resources
  package { $rngd::package_name_array:
    ensure => $rngd::package_ensure,
    before => File[$rngd::config_file_real],
  }

  file { $rngd::config_file_real:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($rngd::config_template),
  }

  if $rngd::service_manage_bool == true {
    service { 'rngd':
      ensure     => $rngd::service_ensure_string,
      enable     => $rngd::service_enable_string,
      name       => $rngd::service_name_real,
      hasstatus  => true,
      hasrestart => true,
      require    => File[$rngd::config_file_real],
      subscribe  => File[$rngd::config_file_real],
    }
  }
  # /configure resources
}
