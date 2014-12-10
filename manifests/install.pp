class rngd::install inherits rngd {

  package { $package_name:
    ensure => $package_ensure,
  }

}