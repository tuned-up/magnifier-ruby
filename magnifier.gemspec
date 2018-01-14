Gem::Specification.new do |gem|
  gem.name        = 'magnifier-ruby'
  gem.version     = '1.1.0'
  gem.summary     = "Anomaly Detection"
  gem.description = "Anomaly detection using gaussian distribution, written in ruby"
  gem.authors     = ["Nick Grysimov"]
  gem.homepage    = 'https://github.com/tuned-up/magnifier-ruby'

  gem.files       = `git ls-files -- lib/*`.split("\n")
  gem.require_paths = %W(lib)

  gem.required_ruby_version = '>= 2.0'

  gem.add_runtime_dependency 'numo-narray', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 3.7.0'
  gem.add_development_dependency 'pry'

  gem.license = 'MIT'
end
