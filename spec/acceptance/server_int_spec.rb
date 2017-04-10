require 'spec_helper_acceptance'

describe 'vision_default' do

  context 'Server Int' do
    it 'should idempotently run' do
    pre = <<-EOS
          file { '/root/.ssh/authorized_keys':
            ensure => present,
          }->
          file_line { 'add ssh key':
            ensure => present,
            path   => '/root/.ssh/authorized_keys',
            line   => 'ssh-rsa THISLINESHOULDBEREMOVED',
          }
      EOS
      pp = <<-EOS

          class vision_puppet::client () {}
          class vision_ssh () {}
          class vision_ntp () {}
          class vision_firewall () {}
          class vision_bareos () {}
          class vision_icinga2 () {}
          class vision_rsyslog () {}
          class vision_pki () {}
          class vision_logcheck () {}
          class vision_exim () {}
          class vision_smart () {}
          class vision_sudo () {}
          class vision_apt::unattended_upgrades () {}
          class ruby () {}


       class { 'vision_default':
         location      => 'int',
         type          => 'server',
         manufacturer  => 'HP',
         dom0_hostname => 'beaker',
         eth0_ip       => '127.0.0.1',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         dns_cnames       => [],
         dns_nameservers  => [],
         dns_search       => [],
         dns_domain       => 'beaker',
        }
      EOS

      apply_manifest(pre, :catch_failures => true)
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'example package installed' do
    describe package('tmux') do
      it { should be_installed }
    end
  end

  context 'unmangaed ssh keys should be purged from accounts' do
    describe file('/root/.ssh/authorized_keys') do
      it { should_not contain 'THISLINESHOULDBEREMOVED' }
    end
  end

  context 'HPE repository enabled' do
    describe file('/etc/apt/sources.list.d/hpe.list') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'hpe.com' }
      its(:content) { is_expected.to match 'jessie' }
    end
    describe package('hpacucli') do
      it { should be_installed }
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
