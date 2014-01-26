Gem::Specification.new do |s|
  # Release Specific Information
  s.version = "0.9.0"
  s.date = "2014-01-24"
  s.licenses = ['MIT']

  # Gem Details
  s.name = "sass-list-maps"
  s.authors = ["Lu Nelson"]
  s.summary = %q{maps-as-lists for libsass and ruby-sass <3.3.x}
  s.description = %q{Forward-compatible maps-functionality using lists. For all versions/compilers of sass which do not have the native map data-type}
  s.email = "lunelson@gmail.com"
  s.homepage = "https://github.com/lunelson/sass-list-maps"

  # Gem Files
  s.files = Dir['README.md','LICENSE','sass-list-maps.scss']
  # s.files = %w(README.md)
  # s.files += Dir.glob("lib/**/*.*")
  # s.files += Dir.glob("stylesheets/**/*.*")

  # Gem Bookkeeping
  s.rubygems_version = %q{1.3.6}
  s.add_dependency("compass", ["~> 0.12"])
  s.add_dependency("sass", ["<= 3.2.14"])
end
