Gem::Specification.new do |s|
  # Release Specific Information
  s.version = "1.0.0-b3"
  s.date = "2014-09-03"
  s.licenses = ['MIT']

  # Gem Details
  s.name = "sass-list-maps"
  s.authors = ["Lu Nelson"]
  s.summary = %q{Map data-type polyfill for libsass 2.0 and ruby-sass < 3.3 using lists}
  s.description = %q{Forward-compatible polyfill for map (hash) data-type functions in libsass 2.0 and ruby-sass < 3.3 using list data-type}
  s.email = "lunelson@gmail.com"
  s.homepage = "https://github.com/lunelson/sass-list-maps"

  # Gem Files
  s.files = Dir['README.md','LICENSE','_sass-list-maps.scss']
  s.files += Dir.glob("lib/**/*.*")

  # Gem Bookkeeping
  s.rubygems_version = %q{1.3.6}
  s.add_dependency("compass", ["~> 0.12.0"])
  s.add_dependency("sass", ["~> 3.2.0"])
end
