require 'spec_helper'

describe 'rngd' do
 let(:title) { 'rngd' }
  let(:facts) { {
    :osfamily => 'RedHat',
  } }

  ['RedHat'].each do |system|
    context "when on system #{system}" do
        let :facts do
          super().merge({ :osfamily => system })
        end
      end


 it { should contain_class('rngd::install') }
 it { should contain_class('rngd::config') }
 it { should contain_class('rngd::service') }

      describe "rngd::config on #{system}" do
        it { should contain_file('/etc/sysconfig/rngd').with_owner('0') }
        it { should contain_file('/etc/sysconfig/rngd').with_group('0') }
        it { should contain_file('/etc/sysconfig/rngd').with_mode('0644') }

        describe 'allows template to be overridden' do
          let(:params) {{ :config_template => 'my_rngd/rngd.erb' }}
          it { should contain_file('/etc/sysconfig/rngd').with({
            'content' => /EXTRAOPTIONS/})
          }
        end
      end

        describe "rngd::install on #{system}" do
          let(:params) {{ :package_ensure => 'present', :package_name => ['rng-tools'], }}

          it { should contain_package('rng-tools').with(
            :ensure => 'present'
          )}

          describe 'should allow package ensure to be overridden' do
            let(:params) {{ :package_ensure => 'latest', :package_name => ['rng-tools'] }}
            it { should contain_package('rng-tools').with_ensure('latest') }
          end

          describe 'should allow the package name to be overridden' do
            let(:params) {{ :package_ensure => 'present', :package_name => ['derp'] }}
            it { should contain_package('derp') }
          end
        end

        describe 'rngd::service' do
          let(:params) {{
            :service_manage => true,
            :service_enable => true,
            :service_ensure => 'running',
            :service_name   => 'rngd'
          }}

          describe 'with defaults' do
            it { should contain_service('rngd').with(
              :enable => true,
              :ensure => 'running',
              :name   => 'rngd'
            )}
          end

          describe 'service_ensure' do
            describe 'when overridden' do
              let(:params) {{ :service_name => 'rngd', :service_ensure => 'stopped' }}
              it { should contain_service('rngd').with_ensure('stopped') }
            end
          end

          describe 'service_manage' do
            let(:params) {{
              :service_manage => false,
              :service_enable => true,
              :service_ensure => 'running',
              :service_name   => 'rng',
            }}

            it 'when set to false' do
              should_not contain_service('rngd').with({
                'enable' => true,
                'ensure' => 'running',
                'name'   => 'rng'
              })
            end
          end
        end
      end
    end
