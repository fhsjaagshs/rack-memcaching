Gem::Specification.new do |s|
  s.name         = "rack-memcaching"
  s.version      = "0.0.1"
  s.authors      = ["Nathaniel Symer"]
  s.email        = ["nate@natesymer.com"]
  s.summary      = "Memcached caching for Rack."
  s.description  = "Add memcached caching to your Rails/Sinatra/Whatever app in a single line of code. Caching happens for GET requests only. Status code, headers, and body are cached. They are stored by REQUEST_URI."    
  s.files        = Dir.glob("{bin,lib}/**/*")
  s.homepage     = "https://github.com/ivytap/rack-memcaching"
  s.license      = "MIT"
  
  s.add_development_dependency "dalli", '~> 0'
  s.add_development_dependency "json", '~> 0'
end
