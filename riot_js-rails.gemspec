# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'riot_js/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'riot_js-rails'
  spec.version       = RiotJs::Rails::VERSION
  spec.authors       = ['Bartosz Jaroszewski']
  spec.email         = ['b.jarosze@gmail.com']

  spec.summary       = %q{Muut Riot integration with Rails.}
  spec.description   = %q{This gem provides integration of Muut Riot with Rails}
  spec.homepage      = 'https://github.com/bjarosze/riot_js-rails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']


  spec.add_dependency 'rails', '>= 3.0', '< 4.3'
  spec.add_dependency 'execjs', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.1'
  spec.add_development_dependency 'byebug', '~> 5.0'
  spec.add_development_dependency 'mocha', '~> 1.0'
end
