# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enumerated_field/version"

AUTHORS = {
  "Luke Ludwig" => "luke.ludwig@tstmedia.com",
  "Patrick Byrne" => "patrick.byrne@tstmedia.com",
  "Jon Karna" => "jon.karna@tstmedia.com",
}

Gem::Specification.new do |s|
  s.name        = "enumerated_field"
  s.version     = EnumeratedField::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = AUTHORS.keys
  s.email       = AUTHORS.values
  s.license     = "MIT"
  s.homepage    = "https://github.com/sportngin/enumerated_field"
  s.summary     = %q{EnumeratedField is a library that provides some nice methods when a string column is used like an enumeration.}
  s.description = %q{EnumeratedField is a library that provides some nice methods when a string column is used like an enumeration, meaning there is a list of allowable values for the string column.}

  s.required_ruby_version = '>= 1.9.3'

  s.rubyforge_project = "enumerated_field"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activemodel', ['> 3.0.0', '< 5.0.0']
  s.add_dependency 'activesupport', ['> 3.0.0', '< 5.0.0']
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'minitest', "~> 4.0"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'turn'
  s.add_development_dependency 'shoulda', '~> 2'
  s.add_development_dependency 'activerecord', '~> 4.0.0'
  s.add_development_dependency 'sqlite3'
end
