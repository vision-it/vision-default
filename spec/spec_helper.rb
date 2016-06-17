require 'rspec-puppet/spec_helper'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')

  c.hiera_config = 'spec/hiera/hiera.yaml'

  # set strict variables setting in puppet if set as env
  if ENV['STRICT_VARIABLES'] == 'yes'
    Puppet.settings[:strict_variables] = true
  end
end
