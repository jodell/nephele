# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nephele}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeffrey O'Dell"]
  s.date = %q{2011-04-07}
  s.default_executable = %q{nephele}
  s.description = %q{Light administration utility for popular cloud services}
  s.email = %q{jeffrey.odell@gmail.com}
  s.executables = ["nephele"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".autotest",
    "Gemfile",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/nephele",
    "lib/nephele.rb",
    "lib/nephele/base.rb",
    "lib/nephele/node.rb",
    "lib/nephele/rackspace.rb",
    "nephele.gemspec",
    "test/helper.rb",
    "test/tc_base.rb"
  ]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Light administration utility for popular cloud services}
  s.test_files = [
    "test/helper.rb",
    "test/tc_base.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<cloudservers>, [">= 0"])
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      s.add_runtime_dependency(%q<optitron>, [">= 0"])
      s.add_development_dependency(%q<wirble>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<autotest-fsevent>, [">= 0"])
      s.add_development_dependency(%q<autotest-growl>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<cloudservers>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<optitron>, [">= 0"])
      s.add_dependency(%q<wirble>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<autotest-fsevent>, [">= 0"])
      s.add_dependency(%q<autotest-growl>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<cloudservers>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<optitron>, [">= 0"])
    s.add_dependency(%q<wirble>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<autotest-fsevent>, [">= 0"])
    s.add_dependency(%q<autotest-growl>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
  end
end
