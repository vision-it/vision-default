require 'spec_helper_acceptance'

describe 'vision_default' do
  context 'Desktop Int' do
    it 'idempotentlies run' do
      pp = <<-FILE

          class ruby () {}
          class vision_apt::unattended_upgrades () {}
          class vision_exim () {}
          class vision_firewall () {}
          class vision_icinga2 () {}
          class vision_logcheck () {}
          class vision_munin () {}
          class vision_ntp () {}
          class vision_pki () {}
          class vision_puppet::client () {}
          class vision_rsyslog () {}
          class vision_smart () {}
          class vision_ssh () {}
          class vision_sudo () {}

          # For Bash Lint
          package{'shellcheck':
            ensure => present,
          }

          group { 'vision-it':
            ensure => present,
          }

        class { 'vision_default':
         location      => 'int',
         type          => 'desktop',
         manufacturer  => 'Something',
         dom0_hostname => 'beaker',
         ip            => '127.0.0.1',
         default_packages => { 'tmux' => {'ensure' => 'present'}},
         sysctl_entries   => { 'fs.inotify.max_user_watches' => { 'value' => '500000' }},
         dns_cnames       => [],
         dns_nameservers  => [],
         dns_search       => [],
         dns_domain       => 'beaker',
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

    describe file('/vision/etc') do
      it { is_expected.to be_directory }
    end

    describe file('/vision/data') do
      it { is_expected.to be_directory }
    end

    describe file('/vision/backup-fileset') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'etc' }
      its(:content) { is_expected.to match 'opt' }
      its(:content) { is_expected.to match 'vision' }
      its(:content) { is_expected.to match 'root' }
    end

    describe file('/opt') do
      it { is_expected.to be_directory }
    end

    describe file('/root/.ssh') do
      it { is_expected.to be_directory }
      it { is_expected.to be_mode 700 }
    end
  end

  context 'xrandr.sh lint' do
    describe package('shellcheck') do
      it { is_expected.to be_installed }
    end

    describe command('/usr/bin/shellcheck //usr/local/bin/xrandr.sh') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  context 'CA files provisioned' do
    describe file('/usr/local/share/ca-certificates/VisionCA.crt') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'Certificate' }
    end
  end

  context 'Desktop files provisioned' do
    describe file('/usr/local/bin/xrandr.sh') do
      its(:content) { is_expected.to match 'mypc' }
      its(:content) { is_expected.to match 'VGA-1' }
      its(:content) { is_expected.to match 'managed by puppet' }
      it { is_expected.to be_file }
      it { is_expected.to be_mode 775 }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'vision-it' }
    end
  end

  context 'Sysctl entries' do
    it 'has applied successfully the inotify.max_user_watches entry' do
      result = on(default, 'sysctl -n fs.inotify.max_user_watches').stdout.strip
      expect(result).to eql('500000')
    end
  end

  context 'zsh provisioned' do
    describe package('zsh') do
      it { is_expected.to be_installed }
    end

    describe file('/root/.zshrc') do
      it { is_expected.to contain 'DISABLE_AUTO_UPDATE="true"' }
      it { is_expected.to be_mode 644 }
    end

    describe file('/root/.oh-my-zsh') do
      it { is_expected.to be_directory }
    end

    describe file('/root/.oh-my-zsh/custom/puppet.zsh') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'This file is managed by puppet' }
    end

    describe file('/root/.oh-my-zsh/custom/path.zsh') do
      it { is_expected.to be_file }
      it { is_expected.to contain '/opt/puppetlabs' }
    end

    describe file('/root/.oh-my-zsh/custom/aliases.zsh') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'This file is managed by Puppet' }
      it { is_expected.to contain "alias e='zile" }
    end

    context 'default shell for user root' do
      describe file('/etc/passwd') do
        it { is_expected.to contain '/root:/usr/bin/zsh' }
      end
    end
  end
end
