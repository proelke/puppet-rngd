# == Class: rngd::config
#
class rngd::config inherits rngd {

    file { $rngd::config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($rngd::config_template),
  }
}