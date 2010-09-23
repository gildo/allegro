$:.unshift File.dirname(__FILE__)
LIBDIR = File.dirname(__FILE__)

require 'yaml'
require 'date'
require 'erb'
require 'rack'
require 'digest'
require 'open-uri'
require 'rdiscount'
require 'builder'
require 'fileutils'

require 'allegro/ext/ext'
require 'allegro/version'
require 'allegro/template'
require 'allegro/site'
require 'allegro/repo'
require 'allegro/context'
require 'allegro/archives'
require 'allegro/article'
require 'allegro/server'

module Allegro
  Paths = {
    :templates => "templates",
    :pages => "templates/pages",
    :articles => "articles"
  }

  def self.env
    ENV['RACK_ENV'] || 'production'
  end

  def self.env= env
    ENV['RACK_ENV'] = env
  end
  
  def self.stub(blog)
    puts "\nAllegro is...\n - \033[32mCreating\033[0m your blog '#{blog}'"
    Dir.mkdir blog

    puts " - \033[32mCopying\033[0m blog template"
    FileUtils.cp_r( Dir.glob(File.join(LIBDIR, 'template/*')), blog )

    puts "\n \033[32mCongratulations, '#{blog}' is ready to go!\033[0m"
  rescue Errno::EEXIST
    puts "\n \033[31muh oh, directory '#{blog}' already exists...\033[0m"
    exit
  end
  
end

