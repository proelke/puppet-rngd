# == Class: rngd::install
#
class rngd::install inherits rngd {

  package { $rngd::package_name:
    ensure => $rngd::package_ensure,
  }

}