$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pretty_formatter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pretty_formatter"
  s.version     = PrettyFormatter::VERSION
  s.authors     = ["Mario A. Chavez"]
  s.email       = ["mario.chavez@gmail.com"]
  s.homepage    = "http://mario-chavez.decisionesinteligentes.com"
  s.summary     = "Log formatter for Rails, format just like BetterLogging gem."
  s.description = "A Rails log formatter that improves the log format, using colors and adding additional information to the log."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activesupport", ">= 3.2"

  s.add_development_dependency 'sqlite3'
end
