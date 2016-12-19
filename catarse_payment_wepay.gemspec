$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "catarse_payment_wepay/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "catarse_payment_wepay"
  s.version     = CatarsePaymentWepay::VERSION
  s.authors     = ["Mark Aufdencamp"]
  s.email       = ["Mark@Aufdencamp.com"]
  s.homepage    = "http://mark.aufdencamp.com"
  s.summary     = "Catarse Payment Processing for Wepay."
  s.description = "Catarse Payment Processing for Wepay."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.22.5"
  s.add_dependency "will_paginate", "~> 3.1.0"
  s.add_dependency "schema_plus", "~> 1.8"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
