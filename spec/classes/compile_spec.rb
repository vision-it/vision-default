require 'spec_helper'
require 'hiera'

describe 'vision_default' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          fqdn: 'debian-test',
          ipaddress: '127.0.0.7'
        )
      end

      let :pre_condition do
        [
          'class ruby () {}',
          'class vision_bareos () {}',
          'class vision_prometheus::exporter::node () {}',
          'class vision_logrotate () {}',
          'class vision_firewall () {}',
          'class vision_icinga2 () {}',
          'class vision_puppet::masterless () {}',
          'class vision_smart () {}',
          'class vision_sudo () {}',
          'package {"zsh": ensure => installed}',
          'realize User["root"]'
        ]
      end

      context 'Server Int' do
        let(:params) do
          {
            type: 'server',
            location: 'int',
            codename: 'jessie'
          }
        end

        it { is_expected.to contain_class('vision_smart') }
        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.not_to contain_class('vision_default::resolv') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'Server DMZ' do
        let(:params) do
          {
            type: 'server',
            location: 'dmz',
            codename: 'jessie',
            dns_domain: 'foobar',
            dns_nameservers: ['127.0.0.1']
          }
        end

        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.to contain_class('vision_smart') }
        it { is_expected.to contain_class('vision_default::resolv') }
        it { is_expected.to compile.with_all_deps }
      end

      context 'Vagrant Development Server' do
        let(:params) do
          {
            type: 'server',
            codename: 'jessie',
            location: 'vrt'
          }
        end

        it { is_expected.to contain_class('vision_default::types::server') }
        it { is_expected.not_to contain_class('vision_smart') }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
