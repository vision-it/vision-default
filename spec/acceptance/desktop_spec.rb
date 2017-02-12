require 'spec_helper_acceptance'

describe 'vision_default' do

  context 'Desktop Int' do
    it 'should idempotently run' do
      pp = <<-EOS

          class vision_puppet::client () {}
          class vision_ssh () {}
          class vision_ntp () {}
          class vision_firewall () {}
          class vision_rsyslog () {}
          class vision_pki () {}
          class vision_logcheck () {}
          class vision_exim () {}
          class vision_munin () {}
          class vision_smart () {}
          class vision_apt::unattended_upgrades () {}

          class ruby () {}

          group { 'vision-it':
            ensure => present,
          }

        class { 'vision_default':
         location      => 'int',
         type          => 'desktop',
         dom0_hostname => 'beaker',
         eth0_ip       => '127.0.0.1',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         sysctl_entries   => { 'fs.inotify.max_user_watches' => { 'value' => '500000' }},
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

  context 'Sysctl entries' do
    it 'should have applied successfully the inotify.max_user_watches entry' do
        result = on(default, 'sysctl -n fs.inotify.max_user_watches').stdout.strip
        expect(result).to eql('500000')
    end
  end
end
