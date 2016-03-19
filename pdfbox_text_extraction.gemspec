# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdfbox_text_extraction/version'

Gem::Specification.new do |spec|
  spec.name          = "pdfbox_text_extraction"
  spec.version       = PdfboxTextExtraction::VERSION
  spec.authors       = ["Jo Hund"]
  spec.email         = ["jhund@clearcove.ca"]
  spec.summary       = %q{Extract plain text from PDF documents.}
  spec.description   = %q{This gem lets you extract plain text from PDF documents. It is a Jruby wrapper for the Apache PDFBox library.}
  spec.homepage      = "https://github.com/jhund/pdfbox_text_extraction"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
