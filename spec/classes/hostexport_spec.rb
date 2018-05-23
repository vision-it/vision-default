require 'spec_helper'
require 'hiera'

describe 'vision_default::hostexport' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'Virtual Server Host Export' do
        let(:params) do
          {
            fqdn: 'debian-test',
            ip: '127.0.0.7',
            dom0_hostname: 'beaker',
            hostname: 'beaker',
            location: 'dmzVm',
            dns_cnames: []
          }
        end

        it { expect(exported_resources).to contain_host('beaker-vm') }
      end
    end
  end
end
