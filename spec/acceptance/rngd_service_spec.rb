require 'spec_helper_acceptance'
require 'specinfra'

case fact('osfamily')
  when 'RedHat'
    servicename = 'rngd'
end
