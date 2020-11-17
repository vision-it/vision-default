require 'spec_helper_acceptance'

describe 'vision_default' do
  context 'Server DMZ' do
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
          package { 'kmod':
           ensure => present
          }
      FILE
      pp = <<-FILE

          class ruby () {}
          class vision_firewall () {}
          class vision_logrotate () {}
          class vision_puppet::masterless () {}
          class vision_smart () {}
          # Docker doesnt like us managing the resolv.conf
          class vision_default::resolv () {}

       class { 'vision_default':
         location      => 'dmz',
         manufacturer  => 'HP',
        }
      FILE

      apply_manifest(pre, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
    end
  end

  context 'example package installed' do
    describe package('tmux') do
      it { is_expected.to be_installed }
    end
  end

  context 'SSH provisioned' do
    describe file('/root/.ssh/authorized_keys') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'beaker' }
      it { is_expected.not_to contain 'THISLINESHOULDBEREMOVED' }
    end

    describe file('/etc/motd') do
      it { is_expected.to contain 'Change me' }
    end

    describe file('/etc/ssh/sshd_config') do
      it { is_expected.to contain 'Port 22' }
      it { is_expected.to contain 'PubkeyAuthentication yes' }
      it { is_expected.to contain 'PermitRootLogin yes' }
      it { is_expected.to contain 'UsePrivilegeSeparation yes' }
      it { is_expected.to contain 'PasswordAuthentication no' }
      it { is_expected.to contain 'PrintMotd yes' }
      it { is_expected.to contain 'StrictModes yes' }
    end

    describe file('/etc/ssh/ssh_config') do
      it { is_expected.to be_file }
      it { is_expected.to be_readable.by('others') }
      it { is_expected.not_to be_writable.by('others') }

      it { is_expected.to contain 'Host x' }
      it { is_expected.to contain('User xxx').after('Host x') }
      it { is_expected.to contain('Hostname xxxample.com').after('Host x') }

      it { is_expected.to contain 'Host foo' }
      it { is_expected.to contain('Hostname foo.bar.com').after('Host foo') }
      it { is_expected.to contain('IdentityFile /home/foo/rsa.key').after('Host foo') }
      it { is_expected.to contain('UserKnownHostsFile /dev/foo').after('Host foo') }

      it { is_expected.to contain 'Host *' }
      it { is_expected.to contain 'HashKnownHosts no' }
    end
  end

  context 'exim files' do
    describe file('/etc/exim4/conf.d/router/160_exim4-config_vision') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'vision' }
    end

    describe file('/etc/exim4/update-exim4.conf.conf') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'Puppet' }
      its(:content) { is_expected.to match 'localhost' }
    end

    describe file('/etc/mailname') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match 'debian' }
    end
  end

  context 'ntp provisioned' do
    describe file('/etc/ntp.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Managed by' }
      it { is_expected.to contain 'driftfile /var/lib/ntp/ntp.drift' }
      it { is_expected.to contain 'restrict foobar nomodify' }
      it { is_expected.to contain 'server bar.foo.de' }
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

  context 'blacklist kernel modules' do
    describe file('/etc/modprobe.d/blacklist-floppy.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'blacklist floppy' }
    end
    describe file('/etc/modprobe.d/blacklist-acpi_power_meter.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'blacklist acpi_power_meter' }
    end
  end
end
