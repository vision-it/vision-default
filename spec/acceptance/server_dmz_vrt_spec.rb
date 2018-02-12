require 'spec_helper_acceptance'

describe 'vision_default' do
  context 'Server DMZ' do
    it 'idempotentlies run' do
      pp = <<-FILE

          class ruby () {}
          class vision_apt::unattended_upgrades () {}
          class vision_bareos () {}
          class vision_editors::zile () {}
          class vision_exim () {}
          class vision_firewall () {}
          class vision_icinga2 () {}
          class vision_logcheck () {}
          class vision_ntp () {}
          class vision_pki () {}
          class vision_puppet::client () {}
          class vision_rsyslog () {}
          class vision_smart () {}
          class vision_ssh () {}
          class vision_sudo () {}

        class { 'vision_default':
         backup_port   => '4444',
         ssh_port      => '5555',
         location      => 'dmzVm',
         manufacturer  => 'Something',
         type          => 'server',
         dom0_hostname => 'beaker',
         hostname      => 'hostname',
         fqdn          => 'beaker',
         eth0_ip       => '127.0.0.1',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         dns_cnames       => [],
         dns_nameservers  => [],
         dns_search       => [],
         dns_domain       => 'beaker',
         blacklist_kernel_modules => { 'floppy' => {'ensure' => 'present'}},
        }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  context 'example package installed' do
    describe package('tmux') do
      it { is_expected.to be_installed }
    end
  end

  context 'files provisioned' do
    describe file('/vision') do
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

  context 'etc hosts' do
    describe file('/etc/hosts') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'ip6-loopback' }
      it { is_expected.to contain 'localhost' }
      it { is_expected.to contain 'beaker' }
      it { is_expected.to contain 'hostname' }
    end
  end

  context 'CA files provisioned' do
    describe file('/usr/local/share/ca-certificates/VisionCA.crt') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Certificate' }
    end
  end

  context 'facts provisioned' do
    describe file('/opt/puppetlabs/facter/facts.d/nodetype.txt') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'server' }
    end

    describe file('/opt/puppetlabs/facter/facts.d/ssh_port.txt') do
      it { is_expected.to be_file }
      it { is_expected.to contain '5555' }
    end

    describe file('/opt/puppetlabs/facter/facts.d/backup_port.txt') do
      it { is_expected.to be_file }
      it { is_expected.to contain '4444' }
    end
  end

  context 'blacklist kernel modules' do
    describe file('/etc/modprobe.d/blacklist-floppy.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'blacklist floppy' }
    end
  end
end
