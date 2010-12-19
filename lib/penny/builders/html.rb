require 'kramdown'

module Penny
  class HTML < Builder
    module Helpers
      def figure(options)
        %{<p class="figure"><img src="#{ASSETS_ROOT}/figures/#{options[:src]}" style="#{options[:style]}" /><cite>Fig <span class="figure-number"></span>.</cite> #{options[:description]}</p>}
      end
      
      def divider(klass)
        %{<hr class="#{klass}" />}
      end
      
      def breakout
        %{<div class="breakout">} + yield + %{</div>}
      end
    end
    
    def render_item(item)
      content = item[:content]
      
      content.gsub!(/\{\{(\S+?)\}\}/) do
        %{<span class="#{$1}"></span>}
      end
      
      content.gsub!(/\[\[(\S+?)\]\]/) do
        %{<div class="#{$1}"></div>}
      end
      
      # Parse with ERB
      ERB.new(content, nil, nil, "@output").result(binding)
      
      # Parse with Kramdown
      content = Kramdown::Document.new(@output).to_html
      
      content.gsub!(/\((http.*?)\)/) do 
        %{(<a href="#{$1}">#{$1}</a>)}
      end
      
      %{<div class="#{item[:types].join(' ')}" id="#{item[:types].last}-#{item[:counter]}">} + content + %{</div>\n\n}
    end
    
    def before_build
    end
    
    include Helpers  
  end
end