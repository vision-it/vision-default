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

      let(:params) {{
                      :type => 'desktop'
                    }}

      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

    end
  end
end
