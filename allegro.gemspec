$LOAD_PATH.unshift 'lib'
require 'allegro/version'

Gem::Specification.new do |s|

  s.name = "allegro"
  s.version = Allegro::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = "a modular CMS in pure ruby"
  s.homepage = "http://github.com/fyskij/allegro"
  s.email = "fiorito.g@gmail.com"
  s.authors = [ "Ermenegildo Fiorito" ]
  s.has_rdoc = false
  s.files = %w( README.md LICENSE )
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("bin/**/*")
  s.executables = %w( allegro )
  s.description       = "a modular CMS in pure ruby"
  s.post_install_message = <<-message
  ...of this astounding life down here
  and of the strange clowns in control of it
  message

end

