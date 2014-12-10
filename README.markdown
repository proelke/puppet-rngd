#rngd

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup](#setup)
    * [What rngd affects](#what-rngd-affects)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)


##Overview

The rngd module installs, configures, and manages the RNGD service.

##Module Description

The rngd module handles installing, configuring, and running RNGD across a range of operating systems and distributions.

##Setup

###What rngd affects

* rngd package.
* rngd configuration file.
* rngd service.

##Usage

All interaction with the rngd module can do be done through the main rngd class.
This means you can simply toggle the options in `::rngd` to have full functionality of the module.

###I just want RNGD, what's the minimum I need?

```puppet
include '::rngd'
```

###I want to set extra options in the config.

```puppet
class { '::rngd':
  extra_options => '-r /dev/urandom -o /dev/random -t 1',
}
```

##Reference

###Classes

####Public Classes

* rngd: Main class, includes all other classes.

####Private Classes

* rngd::install: Handles the packages.
* rngd::config: Handles the configuration file.
* rngd::service: Handles the service.

###Parameters

The following parameters are available in the rngd module:

####`config`

Sets the file that rngd configuration is written into.

####`config_template`

Determines which template Puppet should use for the rngd configuration.

####`extra_options`

Sets the extra options parameter in the rngd config

####`package_ensure`

Sets the rngd package to be installed. Can be set to 'present', 'latest', or a specific version. 

####`package_name`

Determines the name of the package to install.

####`service_enable`

Determines if the service should be enabled at boot.

####`service_ensure`

Determines if the service should be running or not.

####`service_manage`

Selects whether Puppet should manage the service.

####`service_name`

Selects the name of the rngd service for Puppet to manage.

##Limitations

This module has been built on and tested against Puppet 2.7 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5/6
* CentOS 5/6

Testing on other platforms has not been completed. 
