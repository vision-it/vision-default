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

      context 'Server Int' do
        let(:params) do
          {
            type: 'server',
            location: 'int'
          }
        end

        it { is_expected.to contain_class('vision_smart') }
        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.not_to contain_class('resolv_conf') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'Server DMZ' do
        let(:params) do
          {
            type: 'server',
            location: 'dmz',
            dns_domain: 'foobar',
            dns_cnames: [],
            dns_nameservers: ['127.0.0.1']
          }
        end

        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.to contain_class('vision_smart') }
        it { is_expected.to contain_class('resolv_conf') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'Vagrant Development Server' do
        let(:params) do
          {
            type: 'server',
            location: 'vrt'
          }
        end

        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.not_to contain_class('vision_smart') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'Desktop Int' do
        let(:params) do
          {
            type: 'desktop',
            location: 'int'
          }
        end

        it { is_expected.to contain_class('vision_default::types::desktop') }
        it { is_expected.not_to contain_class('vision_smart') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
