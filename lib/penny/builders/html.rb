require 'kramdown'

module Penny
  class HTML < Builder
    module Helpers
      def figure(options)
        @state[:figure] ||= 0
        @state[:figure] += 1
        %{<p class="figure"><img src="#{ASSETS_ROOT}/#{options[:src]}" style="#{options[:style]}" /><cite>Fig <span class="figure-number">#{@item[:chapter]}.#{@state[:figure]}</span>.</cite> #{options[:description]}</p>}
      end
      
      def divider(klass)
        %{<hr class="#{klass}" />}
      end
      
      def breakout
        %{<blockquote class="breakout">} + yield + %{</blockquote>}
      end
      
      def last_figure
        %{<span class="last_figure">#{@item[:chapter]}.#{@state[:figure]}</span>}
      end
      
      def chapter
        @item[:chapter]
      end
    end
    
    def render_item
      @state = {}
      
      # Parse with ERB
      ERB.new(@item[:content], nil, nil, "@output").result(binding)
      
      # Parse with Kramdown
      content = Kramdown::Document.new(@output).to_html
      
      content.gsub!(/\((http.*?)\)/) do 
        %{(<a href="#{$1}">#{$1}</a>)}
      end
      
      %{<div class="#{@item[:types].join(' ')}" id="#{@item[:types].last}-#{@item[:counter]}">} + content + %{</div>\n\n}
    end
    
    def package_build
      content = ''
      
      # Do individual files
      @book.contents.each do |item|
        output_filename = File.join(TEMP_DIR, @book.safe_title + "-" + item[:name] + ".html")
        @book.filelist << output_filename
        item[:rendered_file] = output_filename
        
        content += item[:rendered_content]
        
        File.open(output_filename, "w") do |f|
          f.puts item[:rendered_content]
        end
      end
      
      # Do full page template
      File.open(File.join(TEMP_DIR, @book.safe_title + ".html"), "w") do |f|
        f.puts ERB.new(File.read(template_file(@options[:variant]))).result(binding)
      end
    end
    
    include Helpers
  end
end