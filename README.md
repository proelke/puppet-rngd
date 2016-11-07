#rngd
===

####Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Compatibility](#compatibility)
1. [Setup](#setup)
    * [Managed Resources](#managed-resources)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Parameters](#parameters)

===

#Overview
The rngd module installs, configures, and manages the RNGD service.

#Module Description

The rngd module handles installing, configuring, and running RNGD across a range of operating systems and distributions.

#Compatibility
This module is built for use with Puppet v3 (with and without the future
parser) and Puppet v4 on the following platforms and supports Ruby versions
1.8.7, 1.9.3, 2.0.0, 2.1.0 and 2.3.1.

* EL 5
* EL 6
* EL 7


#Setup
##Managed Resources

* rngd package
* rngd configuration file
* rngd service


#Usage
All interaction with the rngd module can do be done through the main rngd class.
This means you can simply toggle the options in `::rngd` to have full functionality of the module.

####I just want RNGD, what's the minimum I need?

```puppet
include '::rngd'
```

####I want to set extra options in the config.

```puppet
class { '::rngd':
  extra_options => '-r /dev/urandom -o /dev/random -t 1',
}
```

#Parameters
The following parameters are available in the rngd module:

####config_file (string)
Absolute path to rngd configuration file. Configuration will be written to this file. 'USE_DEFAULTS' will choose the file name based on the osfamily.

- *Default*: 'USE_DEFAULTS'


####extra_options (string)
Options that will be used for the EXTRAOPTIONS paramater in rngd configuration file.

- *Default*: undef


####package_ensure (string)
Sets the rngd package to be installed. Can be set to 'present', 'installed', 'absent', 'latest' or a specific version.

- *Default*: 'present'


####package_name (array or string)
String or array for name of package(s). 'USE_DEFAULTS' will choose the package name based on the osfamily.

- *Default*: 'USE_DEFAULTS'


####service_enable (boolean)
Determines if the service should be enabled at boot.

- *Default*: true


####service_ensure (string)
Determines if the service should be running or not. Can be set to 'running' or 'stopped'.

- *Default*: 'running'


####service_manage (boolean)
Selects whether Puppet should manage the service.

- *Default*: true


####service_name (string)
Selects the name of the rngd service for Puppet to manage. 'USE_DEFAULTS' will choose the service name based on the osfamily.

- *Default*: 'USE_DEFAULTS'
