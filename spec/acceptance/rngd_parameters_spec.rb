require 'spec_helper_acceptance'

case fact('osfamily')
  when 'RedHat'
  packagename = 'rng-tools'
end

case fact('osfamily')
  when 'RedHat'
  config = '/etc/sysconfig/rngd'
end

describe "rngd class:", :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'applies successfully' do
    pp = "class { 'rngd': }"

    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stderr).not_to match(/error/i)
    end
  end
end

  describe 'config' do
    it 'sets the rngd config location' do
      pp = "class { 'rngd': config => '/etc/sysconfig/rngd' }"
      apply_manifest(pp, :catch_failures => true)
    end

    describe file('/etc/sysconfig/rngd') do
      it { should be_file }
    end
  end

  describe 'config_template' do
    it 'sets up template' do
      modulepath = default['distmoduledir']
      shell("mkdir -p #{modulepath}/test/templates")
      shell("echo 'testcontent' >> #{modulepath}/test/templates/rngd")
    end

    it 'sets the rngd config location' do
      pp = "class { 'rngd': config_template => 'test/rngd' }"
      apply_manifest(pp, :catch_failures => true)
    end

    describe file("#{config}") do
      it { should be_file }
      its(:content) { should match 'testcontent' }
    end
  end

  describe 'package' do
    it 'installs the right package' do
      pp = <<-EOS
      class { 'rngd':
        package_ensure => present,
        package_name   => #{Array(packagename).inspect},
      }
      EOS
      apply_manifest(pp, :catch_failures => true)
    end

    Array(packagename).each do |package|
      describe package(package) do
        it { should be_installed }
      end
    end
  end
