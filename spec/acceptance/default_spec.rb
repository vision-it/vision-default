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
          class vision_groups::ssl_cert () {}
          class ruby () {}
          package { "zsh": }


        class { 'vision_default':
         location      => 'int',
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

end
