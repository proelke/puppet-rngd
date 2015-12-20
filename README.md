#rngd
===

####Table of Contents

1. [Overview](#overview)
2. [Compatibility](#compatibility)
3. [Module Description - What the module does and why it is useful](#module-description)
4. [Setup](#setup)
    * [Managed Resources](#managed-resources)
5. [Usage - Configuration options and additional functionality](#usage)
6. [Parameters](#parameters)
6. [Limitations - OS compatibility, etc.](#limitations)

===

#Overview
The rngd module installs, configures, and manages the RNGD service.

#Module Description

The rngd module handles installing, configuring, and running RNGD across a range of operating systems and distributions.

#Setup
##Managed Resources

* rngd package
* rngd configuration file
* rngd service

# Compatibility
This module is built for use with Puppet v3 (with and without the future
parser) and Puppet v4 on the following platforms and supports Ruby versions
1.8.7, 1.9.3, 2.0.0 and 2.1.0.

* EL 5
* EL 6


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


####config_template (string)
Path and name to the template that should be used for the rngd configuration file.

- *Default*: 'rngd/rngd.erb'


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


####service_ensure (string or boolean)
Determines if the service should be running or not. Can be set to 'running', 'stopped', 'true' or 'false'.

- *Default*: 'running'


####service_manage (boolean)
Selects whether Puppet should manage the service.

- *Default*: true


####service_name (string)
Selects the name of the rngd service for Puppet to manage. 'USE_DEFAULTS' will choose the service name based on the osfamily.

- *Default*: 'USE_DEFAULTS'


##Limitations
This module has been built on and tested against Puppet 2.7 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5
* RedHat Enterprise Linux 6
* CentOS 5
* CentOS 6

Testing on other platforms has not been completed. 
