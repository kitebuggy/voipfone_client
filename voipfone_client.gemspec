# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'voipfone_client/version'

Gem::Specification.new do |spec|
  spec.name          = "voipfone_client"
  spec.version       = VoipfoneClient::VERSION
  spec.authors       = ["Error Creative Studio"]
  spec.email         = ["ed@errorstudio.co.uk"]
  spec.summary       = %q{A client for voipfone.co.uk, a UK-based SIP provider}
  spec.description   = %q{Voipfone are a brilliant SIP provider with loads of features, but no API. This Gem hooks into the API which their web interfaces uses.}
  spec.homepage      = "https://github.com/errorstudio/voipfone_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"

  spec.add_dependency "mechanize", "~> 2.7"
end
