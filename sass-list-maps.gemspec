Gem::Specification.new do |s|
  # Release Specific Information
  s.version = "0.9.9"
  s.date = "2014-04-29"
  s.licenses = ['MIT']

  # Gem Details
  s.name = "sass-list-maps"
  s.authors = ["Lu Nelson"]
  s.summary = %q{Map (hash) data in libsass and ruby-sass < 3.3}
  s.description = %q{Forward-compatible map (hash) manipulation functions for libsass and ruby-sass < 3.3}
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
