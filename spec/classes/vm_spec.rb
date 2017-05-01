require 'spec_helper'
require 'hiera'

describe 'vision_default' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(fqdn: 'debian-test',
                    ipaddress: '127.0.0.7')
      end

      let :pre_condition do
        [
          'class vision_puppet::client () {}',
          'class vision_ssh () {}',
          'class vision_icinga2 () {}',
          'class vision_pki () {}',
          'class vision_logcheck () {}',
          'class vision_bareos () {}',
          'class vision_apt::unattended_upgrades () {}',
          'class vision_exim () {}',
          'class vision_firewall () {}',
          'class vision_ntp () {}',
          'class vision_smart () {}',
          'class vision_sudo () {}',
          'class vision_rsyslog () {}',
          'class vision_groups () {}',
          'class ruby () {}'
        ]
      end

      context 'Virtual Server DMZ' do
        let(:params) do
          {
            type: 'server',
            backup_port: '2323',
            location: 'dmzVm'
          }
        end

        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.not_to contain_class('vision_smart') }
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/opt/puppetlabs/facter/facts.d/backup_port.txt').with(
                           'ensure'  => 'present',
                           'content' => 'backup_port=2323'
                         )
        end
      end

      context 'Virtual Server DMZ calculate backup_port' do
        let(:params) do
          {
            type: 'server',
            location: 'dmzVm'
          }
        end

        it do
          is_expected.to contain_file('/opt/puppetlabs/facter/facts.d/backup_port.txt').with(
                           'ensure'  => 'present',
                           'content' => 'backup_port=2307'
                         )
        end
      end
    end
  end
end
