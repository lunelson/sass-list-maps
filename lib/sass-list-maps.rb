require 'compass'
extension_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
base_directory  = File.join(File.dirname(__FILE__), '..')
stylesheets_dir = extension_path
Compass::Frameworks.register('sass-list-maps', :path => extension_path, :stylesheets_directory => stylesheets_dir)