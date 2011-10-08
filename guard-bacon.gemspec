# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/guard-bacon/version"

Gem::Specification.new do |s|
  s.name        = "guard-bacon"
  s.version     = Guard::Guard::VERSION
  s.authors     = ["Julien Ammous"]
  s.email       = ["schmurfy@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Guard for bacon}
  s.description = %q{Run your bacon specs on file change}

  s.rubyforge_project = "guard-bacon"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency "guard"
  s.add_runtime_dependency "schmurfy-bacon", "~> 1.2"
end
