lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "atmospheric/version"

Gem::Specification.new do |spec|
  spec.name          = "atmospheric"
  spec.version       = Atmospheric::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.homepage      = "https://github.com/metanorma/atmospheric"
  spec.summary       = <<~HERE.strip
    Implementation of International Standard Atmosphere (ISA) formulas"
  HERE
  spec.description = <<~HERE.strip
    Implementation of International Standard Atmosphere (ISA) formulas as
    defined in ISO 2533:1975 and ICAO 7488/3 1994"
  HERE
  spec.license       = "BSD-2-Clause"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select do |f|
      f.match(%r{^(lib|exe)/}) || f.match(%r{\.yaml$})
    end
  end
  spec.extra_rdoc_files = %w[README.adoc LICENSE.txt]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.add_dependency "lutaml-model", "~> 0.4.0"
  spec.add_runtime_dependency "bigdecimal"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
