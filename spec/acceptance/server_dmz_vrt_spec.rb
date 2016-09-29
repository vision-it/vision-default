require 'spec_helper_acceptance'

describe 'vision_default' do

  context 'Server DMZ' do
    it 'should idempotently run' do
      pp = <<-EOS

          class vision_puppet::client () {}
          class vision_ssh () {}
          class vision_ntp () {}
          class vision_editors::vim () {}
          class vision_rsyslog () {}
          class vision_pki () {}
          class vision_logcheck () {}
          class vision_exim () {}
          class vision_munin () {}
          class vision_nagios::client () {}
          class vision_smart () {}
          class vision_apt::unattended_upgrades () {}
          class ruby () {}

        class { 'vision_default':
         location      => 'dmzVm',
         type          => 'server',
         dom0_hostname => 'beaker',
         eth0_ip       => '127.0.0.1',
         repo_key      => 'foobar',
         repo_keyid    => '9E3E53F19C7DE460',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         dns_cnames       => [],
         dns_nameservers  => [],
         dns_search       => [],
         dns_domain       => 'beaker',
         blacklist_kernel_modules => { 'floppy' => {'ensure' => 'present'}},
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

  context 'blacklist kernel modules' do
    describe file('/etc/modprobe.d/blacklist-floppy.conf') do
      it { should be_file }
      it { should contain 'blacklist floppy' }
    end
  end

end
