module Allegro

  class Article < Hash
    include Template

    def initialize obj, config = {}
      @obj, @config = obj, config
      self.load if obj.is_a? Hash
    end

    def load
      data = if @obj.is_a? String
      meta, self[:body] = File.read(@obj).split(/\n\n/, 2)

      # use the date from the filename, or else allegro won't find the article
      @obj =~ /\/(\d{4}-\d{2}-\d{2})[^\/]*$/
        ($1 ? {:date => $1} : {}).merge(YAML.load(meta))
      elsif @obj.is_a? Hash
        @obj
      end.inject({}) {|h, (k,v)| h.merge(k.to_sym => v) }

      self.taint
      self.update data
      self[:date] = Date.parse(self[:date].gsub('/', '-')) rescue Date.today
      self
    end

      def [] key
        self.load unless self.tainted?
        super
      end

      def slug
        self[:slug] || self[:title].slugize
      end

      def summary length = nil
        config = @config[:summary]
        sum = if self[:body] =~ config[:delim]
          self[:body].split(config[:delim]).first
        else
          self[:body].match(/(.{1,#{length || config[:length] || config[:max]}}.*?)(\n|\Z)/m).to_s
        end
        markdown(sum.length == self[:body].length ? sum : sum.strip.sub(/\.\Z/, '&hellip;'))
      end

      def url
        "http://#{(@config[:url].sub("http://", '') + self.path).squeeze('/')}"
      end
      alias :permalink url

      def body
        markdown self[:body].sub(@config[:summary][:delim], '') rescue markdown self[:body]
      end

      def path
      "/#{@config[:prefix]}#{self[:date].strftime("/%Y/%m/%d/#{slug}/")}".squeeze('/')
      end

    def title()   self[:title] || "an article"               end
    def date()    @config[:date].call(self[:date])           end
    def author()  self[:author] || @config[:author]          end
    def to_html() self.load; super(:article, @config)        end
    alias :to_s to_html
  end

  class Config < Hash
    Defaults = {
      :author => ENV['USER'],                               # blog author
      :title => Dir.pwd.split('/').last,                    # site title
      :root => "index",                                     # site index
      :url => "http://127.0.0.1",                           # root URL of the site
      :prefix => "",                                        # common path prefix for the blog
      :date => lambda {|now| now.strftime("%d/%m/%Y") },    # date function
      :markdown => :smart,                                  # use markdown
      :disqus => false,                                     # disqus name
      :summary => {:max => 150, :delim => /~\n/},           # length of summary and delimiter
      :ext => 'txt',                                        # extension for articles
      :cache => 28800,                                      # cache duration (seconds)
      :github => {:user => "", :repos => [], :ext => 'md'}, # Github username and list of repos
      :to_html => lambda {|path, page, ctx|                 # returns an html, from a path & context
        ERB.new(File.read("#{path}/#{page}.rhtml")).result(ctx)
      },
      :error => lambda {|code|                              # The HTML for your error page
        "<font style='font-size:300%'>allegro, we're not in Kansas anymore (#{code})</font>"
      }
    }
    def initialize obj
      self.update Defaults
      self.update obj
    end

    def set key, val = nil, &blk
      if val.is_a? Hash
        self[key].update val
      else
        self[key] = block_given?? blk : val
      end
    end
  end

end

