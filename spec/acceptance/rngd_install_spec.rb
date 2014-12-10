require 'spec_helper_acceptance'

case fact('osfamily')
when 'RedHat'
    servicename = 'rng-tools'
end

describe 'rngd::install class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'installs the package' do
    apply_manifest(%{
      class { 'rngd': }
    }, :catch_failures => true)
  end

  Array(packagename).each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
end
