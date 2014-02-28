Gem::Specification.new do |s|
  # Release Specific Information
  s.version = "0.9.5"
  s.date = "2014-02-28"
  s.licenses = ['MIT']

  # Gem Details
  s.name = "sass-list-maps"
  s.authors = ["Lu Nelson"]
  s.summary = %q{Maps for libsass and ruby-sass 3.2.x}
  s.description = %q{Forward-compatible map functionality for libsass and ruby-sass 3.2.x}
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
