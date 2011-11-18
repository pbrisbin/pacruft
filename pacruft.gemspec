# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pacruft/version"

Gem::Specification.new do |s|
  s.name = "pacruft"
  s.version     = Pacruft::VERSION
  s.authors = ["Patrick Brisbin"]
  s.email = "pbrisbin@gmail.com"
  s.homepage = "http://github.com/pbrisbin/pacruft"
  s.summary = "remove old and unused pacman packages"
  s.description = %{By looking at the mtime of packages' owned files,
  pacruft tried to show you packages you haven't used in a while and
  could probaly do without.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.licenses      = ["MIT"]
end
