# coding: UTF-8
require File.expand_path('../lib/creatary/version', __FILE__)

Gem::Specification.new do |s|
  s.add_runtime_dependency('sinatra', '~> 1.2.1')
  s.add_runtime_dependency('json', '~> 1.5')
  s.add_runtime_dependency('oauth', '~> 0.4.3')
  
  s.add_development_dependency('rake', '0.9.2')
  s.add_development_dependency('rspec', '~> 2.7')
  s.add_development_dependency('rack-test', "~> 0.6.1")
  s.add_development_dependency('mocha', '~> 0.9.0')
  s.add_development_dependency('webmock', '~> 1.7.0')
  s.add_development_dependency('simplecov', '~> 0.5.0')
    
  s.name                      = "creatary-sdk"
  s.version                   = Creatary::VERSION.dup
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Carlos Manzanares"]
  s.email                     = ["developers@creatary.com"]
  s.homepage                  = "https://github.com/creatary/creatary-ruby-sdk"
  s.description               = %q{The Ruby gem for the Creatary REST APIs}
  s.summary                   = "Creatary Ruby gem"
  s.rubyforge_project         = s.name

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  
  s.require_path              = 'lib'
  s.executables               = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files                     = `git ls-files`.split("\n")
  s.test_files                = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.post_install_message =<<eos
********************************************************************************

  Visit our community pages for up-to-date information on 
  Creatary:
      https://creatary.com/
  Notice that in order to use this gem you will also need to register as a 
  developer in Creatary

********************************************************************************  
eos
end