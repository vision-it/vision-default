require 'spec_helper'
require 'hiera'

describe 'vision_default' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let :pre_condition do
        [
          'class vision_puppet::client () {}',
          'class vision_ssh () {}',
          'class vision_munin () {}',
          'class vision_pki () {}',
          'class vision_logcheck () {}',
          'class vision_apt::unattended_upgrades () {}',
          'class vision_exim () {}',
          'class vision_ntp () {}',
          'class vision_smart () {}',
          'class vision_editors::vim () {}',
          'class vision_shells::zsh () {}',
          'class vision_rsyslog () {}',
          'class vision_groups::ssl_cert () {}',
          'class ruby () {}',
          'package { "zsh": }'
        ]
      end

      context 'Server Int' do

        let(:params) {{
                        :type => 'server',
                        :location => 'int'
                      }}

        it { is_expected.to contain_class('vision_smart') }
        it { is_expected.to compile.with_all_deps }

        it { expect(exported_resources).to contain_user('root') }
      end


      context 'Virtual Server DMZ' do

        let(:params) {{
                        :type => 'server',
                        :location => 'dmzVm'
                      }}

        it { is_expected.to compile.with_all_deps }

      end


      context 'Server DMZ' do

        let(:params) {{
                        :type => 'server',
                        :location => 'dmz'
                      }}

        it { is_expected.to contain_class('resolv_conf') }
        it { is_expected.to compile.with_all_deps }

      end


      context 'Desktop Int' do

        let(:params) {{
                      :type => 'desktop'
                    }}

        it { is_expected.to compile.with_all_deps }

      end

    end
  end
end
