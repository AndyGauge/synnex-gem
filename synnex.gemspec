
Gem::Specification.new do |spec|
  spec.name          = "synnex"
  spec.version       = '0.1.4'
  spec.authors       = ["Andrew Gauger"]
  spec.email         = ["andygauge@gmail.com"]

  spec.summary       = "API access to Synnex ECExpress Stellr Cloud"
  spec.description   = "Wraps the API up in object for managing office 365 licenses through Partner CSP"
  spec.homepage      = "http://www.yetanother.site"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andygauge/synnex-gem"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.add_runtime_dependency "httparty"
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
