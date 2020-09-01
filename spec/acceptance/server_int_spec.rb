require 'spec_helper_acceptance'

describe 'vision_default' do
  context 'Server Int' do
    it 'idempotentlies run' do
      pre = <<-FILE
          file { '/root/.ssh/authorized_keys':
            ensure => present,
          }->
          file_line { 'add ssh key':
            ensure => present,
            path   => '/root/.ssh/authorized_keys',
            line   => 'ssh-rsa THISLINESHOULDBEREMOVED',
          }
      FILE
      pp = <<-FILE

          class ruby () {}
          class vision_auditd () {}
          class vision_bareos () {}
          class vision_prometheus::exporter::node () {}
          class vision_exim () {}
          class vision_firewall () {}
          class vision_icinga2 () {}
          class vision_logrotate () {}
          class vision_ntp () {}
          class vision_puppet::masterless () {}
          class vision_smart () {}
          class vision_ssh () {}
          class vision_sudo () {}

       class { 'vision_default':
         location      => 'int',
         codename      => 'stretch',
         type          => 'server',
         manufacturer  => 'HP',
         ip            => '127.0.0.1',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         dns_nameservers  => [],
         dns_search       => [],
         dns_domain       => 'beaker',
        }
      FILE

      apply_manifest(pre, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'example package installed' do
    describe package('tmux') do
      it { is_expected.to be_installed }
    end
  end

  context 'unmangaed ssh keys should be purged from accounts' do
    describe file('/root/.ssh/authorized_keys') do
      it { is_expected.not_to contain 'THISLINESHOULDBEREMOVED' }
    end
  end

  context 'HPE repository enabled' do
    if os[:release].to_i == 9
      describe file('/etc/apt/sources.list.d/hpe.list') do
        it { is_expected.to exist }
        its(:content) { is_expected.to match 'hpe.com' }
        its(:content) { is_expected.to match 'stretch/current' }
      end
    end
    if os[:release].to_i == 10
      describe file('/etc/apt/sources.list.d/hpe.list') do
        it { is_expected.to exist }
        its(:content) { is_expected.to match 'hpe.com' }
        its(:content) { is_expected.to match 'buster/current' }
      end
    end
    describe package('ssacli') do
      it { is_expected.to be_installed }
    end
  end

  context 'resolv not provisioned' do
    describe file('/etc/resolv.conf') do
      it { is_expected.not_to contain 'Puppet' }
    end
  end

  context 'files provisioned' do
    describe file('/vision') do
      it { is_expected.to be_directory }
    end

    describe file('/vision/etc') do
      it { is_expected.to be_directory }
    end

    describe file('/vision/data') do
      it { is_expected.to be_directory }
    end

    describe file('/opt') do
      it { is_expected.to be_directory }
    end

    describe file('/root/.ssh') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
    end
  end

  context 'CA files provisioned' do
    describe file('/usr/local/share/ca-certificates/VisionCA.crt') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Certificate' }
    end
  end

  context 'unattended upgrades' do
    describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'label=Debian-Security' }
      it { is_expected.to contain 'Reboot "false"' }
    end
    describe package('unattended-upgrades') do
      it { is_expected.to be_installed }
    end
  end

  context 'rsyslog provisioned' do
    describe file('/etc/rsyslog.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to contain 'This file is managed by puppet' }
    end

    describe file('/etc/rsyslog.d/firewall.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to contain 'iptables' }
    end

    describe file('/etc/rsyslog.d/puppet.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      it { is_expected.to contain 'local6.* /var/log/puppetlabs/puppet/agent.log' }
    end
  end

  context 'blacklist kernel modules' do
    describe file('/etc/modprobe.d/blacklist-floppy.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'blacklist floppy' }
    end
  end
end
