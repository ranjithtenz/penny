# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "penny/version"

Gem::Specification.new do |s|
  s.name        = "penny"
  s.version     = Penny::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Cooper"]
  s.email       = ["peter@petercooper.co.uk"]
  s.homepage    = "https://github.com/peterc/penny"
  s.summary     = %q{Multi-format e-book generation system}
  s.description = %q{Penny is a flexible e-book generation system for working with multiple toolchains and compilation flows}

  s.rubyforge_project = "penny"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'kramdown' 
  s.add_dependency 'eeepub'
end
