module Penny
  class Builder
    def template(name = nil)
      if name
        @template = name
      else
        @template || self.class.name[/\w+$/].to_s.downcase
      end
    end
    
    def template_file(variant = nil)
      File.join(CONTENT_ROOT, "template" + (variant ? "." + variant : '') + ".#{template.downcase}")
    end
    
    def initialize(book, options = {})
      @book = book
      @options = options
    end
    
    def build      
      respond_to?(:before_build) && before_build
    
      @book.contents.each do |item|
        @item = item
        @item[:content] = File.read(@item[:content_file])
        next unless @item[:content]
        @item[:rendered_content] = render_item
      end
      
      respond_to?(:after_build) && after_build
        
      package_build
      
      @book = nil
    end
    
    def metadata
      return false unless @book
      @book && @book.metadata
    end
    

    
  end
end