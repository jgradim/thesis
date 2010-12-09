# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{marshalled_associations}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["João Gradim"]
  s.date = %q{2010-12-09}
  s.description = %q{Dummy description}
  s.email = %q{joao.gradim@gmail.com}
  s.extra_rdoc_files = ["lib/callable_hash.rb", "lib/class_level_inheritable_attributes.rb"]
  s.files = ["Rakefile", "lib/callable_hash.rb", "lib/class_level_inheritable_attributes.rb", "marshalled_associations.gemspec", "Manifest"]
  s.homepage = %q{http://github.com/jgradim/marshalled_associations}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Marshalled_associations"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{marshalled_associations}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Dummy description}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
