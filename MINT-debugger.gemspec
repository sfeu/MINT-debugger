# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{MINT-debugger}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Sebastian Feuerstack}]
  s.date = %q{2011-10-17}
  s.description = %q{}
  s.email = [%q{Sebastian@Feuerstack.org}]
  s.executables = [%q{mint-debugger}]
  s.extra_rdoc_files = [%q{History.txt}, %q{Manifest.txt}, %q{README.txt}, %q{lib/MINT-debugger/licence-code.txt}]
  s.files = [%q{History.txt}, %q{MINT-debugger.gemspec}, %q{Manifest.txt}, %q{README.txt}, %q{Rakefile}, %q{bin/mint-debugger}, %q{lib/MINT-debugger.rb}, %q{lib/MINT-debugger/MINT-Logo-short-bg.png}, %q{lib/MINT-debugger/debugger2.rb}, %q{lib/MINT-debugger/licence-code.txt}, %q{.gemtest}]
  s.rdoc_options = [%q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{MINT-debugger}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<MINT-core>, ["~> 0.0.1"])
      s.add_runtime_dependency(%q<wxruby>, ["~> 2.0.0"])
      s.add_development_dependency(%q<hoe>, ["~> 2.9"])
    else
      s.add_dependency(%q<MINT-core>, ["~> 0.0.1"])
      s.add_dependency(%q<wxruby>, ["~> 2.0.0"])
      s.add_dependency(%q<hoe>, ["~> 2.9"])
    end
  else
    s.add_dependency(%q<MINT-core>, ["~> 0.0.1"])
    s.add_dependency(%q<wxruby>, ["~> 2.0.0"])
    s.add_dependency(%q<hoe>, ["~> 2.9"])
  end
end
