# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/licenses/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-licenses"
  s.version     = OpenProject::Licenses::VERSION
  s.authors     = "OpenProject GmbH, Francisco de Juan, Enrique García Cota"
  s.email       = "info@openproject.org"
  s.homepage    = "https://github.com/opf/openproject-licenses"
  s.summary     = 'OpenProject Licenses'
  s.description = "Adds Licenses support to OpenProject."
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", "~> 5.0"
end
