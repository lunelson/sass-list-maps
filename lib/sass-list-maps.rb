require 'compass'
extension_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
base_directory  = File.join(File.dirname(__FILE__), '..')
# stylesheets_dir = base_directory
Compass::Frameworks.register(
	'sass-list-maps',
	:path => extension_path,
	:stylesheets_directory => base_directory
)