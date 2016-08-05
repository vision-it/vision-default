require 'spec_helper_acceptance'

describe 'vision_default' do

  context 'with defaults' do
    it 'should idempotently run' do
      pp = <<-EOS

          class vision_puppet::client () {}
          class vision_ssh () {}
          class vision_ntp () {}
          class vision_editors::vim () {}
          class vision_shells::zsh () {}
          class vision_rsyslog () {}
          class vision_pki () {}
          class vision_logcheck () {}
          class vision_exim () {}
          class vision_munin () {}
          class vision_smart () {}
          class vision_apt::unattended_upgrades () {}
          class vision_groups::ssl_cert () {}
          class ruby () {}
          package { "zsh": }


        class { 'vision_default':
         location      => 'int',
         type          => 'desktop',
         dom0_hostname => 'beaker',
         eth0_ip       => '127.0.0.1',
         repo_key      => 'foobar',
         repo_keyid    => '9E3E53F19C7DE460',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         dns_cnames       => [],
         dns_nameservers  => [],
         dns_search       => [],
         dns_domain       => 'beaker',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'example package installed' do
    describe package('tmux') do
      it { should be_installed}
    end
  end

  context 'files provisioned' do
    describe file('/vision') do
      it { should be_directory }
    end

    describe file('/opt') do
      it { should be_directory }
    end

    describe file('/root/.ssh') do
      it { should be_directory }
      it { should be_mode 700 }
    end
  end

  context 'CA files provisioned' do
    describe file('/usr/local/share/ca-certificates/VisionCA.crt') do
      it { should be_file }
      it { should contain 'Certificate' }
    end
  end

  context 'Desktop files provisioned' do
    describe file('/usr/local/bin/xrandr.sh') do
      it { should be_file }
      it { should be_mode 775 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'vision-it' }
    end
  end

end
