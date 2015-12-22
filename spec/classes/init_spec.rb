require 'spec_helper'
describe 'rngd' do
  let(:facts) do
    {
      :osfamily => 'RedHat',
    }
  end
  config_file_content = <<-END.gsub(/^\s+\|/, '')
    |# This file is being maintained by Puppet.
    |# DO NOT EDIT
    |#
    |# Add extra options here
    |EXTRAOPTIONS=""
  END

  context 'with defaults for all parameters on valid osfamily <RedHat>' do
    it { should compile.with_all_deps }
    it { should contain_class('rngd') }
    it do
      should contain_package('rng-tools').with({
        'ensure' => 'present',
        'before' => 'File[rngd_config]',
      })
    end
    it do
      should contain_file('rngd_config').with({
        'ensure'  => 'file',
        'path'    => '/etc/sysconfig/rngd',
        'owner'   => '0',
        'group'   => '0',
        'mode'    => '0644',
        'content' => config_file_content,
      })
    end
    it do
      should contain_service('rngd').with({
        'ensure'     => 'running',
        'enable'     => true,
        'name'       => 'rngd',
        'hasstatus'  => true,
        'hasrestart' => true,
        'subscribe'  => 'File[rngd_config]',
      })
    end
  end

  context 'when config_file is set to valid </etc/sysconfig/rngd_test> (as String)' do
    let(:params) { { :config_file => '/etc/sysconfig/rngd_test' } }
    it { should contain_file('rngd_config').with({ 'path' => '/etc/sysconfig/rngd_test' }) }
  end

  context 'when extra_options is set to valid <-r /dev/urandom> (as String)' do
    let(:params) { { :extra_options => '-r /dev/urandom' } }
    it do
      should contain_file('rngd_config').with_content(
        %r{^EXTRAOPTIONS="-r /dev/urandom"$}
      )
    end
  end

  context 'when package_ensure is set to valid <installed> (as String)' do
    let(:params) { { :package_ensure => 'installed' } }
    it { should contain_package('rng-tools').with_ensure('installed') }
  end

  ['rngd', %w(rngd rngd-tools)].each do |value|
    context "when package_name is set to valid <#{value}> (as #{value.class})" do
      let(:params) { { :package_name => value } }
      if value.class == Array
        value.each do |package|
          it { should contain_package(package) }
        end
      else
        it { should contain_package(value) }
      end
    end
  end

  context 'when service_ensure is set to valid <stopped> (as String)' do
    let(:params) { { :service_ensure => 'stopped' } }
    it { should contain_service('rngd').with_ensure('stopped') }
  end

  context 'when service_manage is set to valid <false> (as String)' do
    let(:params) { { :service_manage => 'false' } }
    it { should_not contain_service('rngd') }
  end

  context 'when service_name is set to valid <rng-new> (as String)' do
    let(:params) { { :service_name => 'rng-new' } }
    it { should contain_service('rngd').with_name('rng-new') }
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        :osfamily => 'RedHat',
      }
    end
    let(:validation_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'absolute_path' => {
        :name    => %w(config_file),
        :valid   => %w(/absolute/filepath /absolute/directory/),
        :invalid => ['../invalid', 3, 2.42, %w(array), { 'ha' => 'sh' }, true, false, nil],
        :message => 'is not an absolute path',
      },
      'array/string' => {
        :name    => %w(package_name),
        :valid   => [%w(ar ray), 'string'],
        :invalid => [{ 'ha' => 'sh' }, 3, 2.42, true, false],
        :message => 'is not a string nor an array',
      },
      'bool_stringified' => {
        :name    => %w(service_manage service_enable),
        :valid   => [true, false, 'true', 'false'],
        :invalid => ['invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42],
        :message => '(Unknown type of boolean|str2bool\(\): Requires either string to work with)',
      },
      'regex_package_ensure' => {
        :name    => %w(package_ensure),
        :valid   => %w(present installed absent latest),
        :invalid => ['purged', 'held', 'invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42, true, false, nil],
        :message => 'must be present, installed, absent or latest',
      },
      'regex_service_ensure' => {
        :name    => %w(service_ensure),
        :valid   => ['running', 'stopped'],
        :invalid => ['invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42, nil, true],
        :message => 'must be running or stopped',
      },
      'string' => {
        :name    => %w(extra_options service_name),
        :valid   => ['present'],
        :invalid => [%w(array), { 'ha' => 'sh' }],
        :message => 'is not a string',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge({ :"#{var_name}" => valid, }) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge({ :"#{var_name}" => invalid, }) }
            it 'should fail' do
              expect do
                should contain_class(subject)
              end.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
