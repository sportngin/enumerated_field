# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "enumerated_field/version"

Gem::Specification.new do |s|
  s.name        = "enumerated_field"
  s.version     = EnumeratedField::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luke Ludwig"]
  s.email       = ["luke.ludwig@tstmedia.com"]
  s.homepage    = "https://github.com/tstmedia/enumerated_field"
  s.summary     = %q{EnumeratedField is a library that provides some nice methods when a string column is used like an enumeration.}
  s.description = %q{EnumeratedField is a library that provides some nice methods when a string column is used like an enumeration, meaning there is a list of allowable values for the string column.}

  s.rubyforge_project = "enumerated_field"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'turn'
  s.add_development_dependency 'shoulda'
end
