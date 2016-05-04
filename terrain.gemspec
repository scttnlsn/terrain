lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'terrain'
  gem.version       = '0.0.0'
  gem.summary       = 'Terrain'
  gem.description   = ''
  gem.license       = 'MIT'
  gem.authors       = ['Scott Nelson']
  gem.email         = 'scott@scottnelson.co'
  gem.homepage      = 'https://github.com/scttnlsn/terrain'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'activesupport', '>= 4.0'
  gem.add_dependency 'pundit', '1.1.0'
  gem.add_dependency 'active_model_serializers', '>= 0.10.0.rc5'
end
