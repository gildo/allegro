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
  s.files = %w( README.md )
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("bin/**/*")
  s.executables = %w( allegro )
  s.add_dependency(%q<builder>, [">= 0"])
  s.add_dependency(%q<rack>, [">= 0"])
  s.add_dependency(%q<rdiscount>, [">= 0"])

  s.description       = "a modular CMS in pure ruby"
  s.post_install_message = <<-message


  ...of this astounding life down here
  and of the strange clowns in control of it

  -L. F.


  message

end

