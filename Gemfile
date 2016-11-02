source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['4.6.1']
gem 'puppet', puppetversion,    :require => false
gem 'puppetlabs_spec_helper',   :require => false
gem 'metadata-json-lint',       :require => false
gem 'rspec-puppet',             :require => false
gem 'rspec-puppet-facts',       :require => false
gem 'rake',                     :require => false
# beaker related gems
gem 'beaker-rspec', '5.6.0'
gem 'serverspec',               :require => false
gem 'specinfra',                :require => false
