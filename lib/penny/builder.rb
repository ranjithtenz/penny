module Penny
  class Builder
    def template(name = nil)
      if name
        @template = name
      else
        @template || self.class.name[/\w+$/]
      end
    end
    
    def template_file(variant = nil)
      File.join(CONTENT_ROOT, "template" + (variant ? "." + variant : '') + ".#{template.downcase}")
    end
    
    def build(book, options = {})
      @book = book
      @content = ''
      
      respond_to?(:before_build) && before_build
    
      @book.contents.each do |item|
        item[:content] = File.read(find_file(item[:file])) rescue nil
        next unless item[:content]
    
        @content << render_item(item)
      end        
      
      respond_to?(:after_build) && after_build
      
      content = @content
    
      File.open(File.join(TEMP_DIR, @book.safe_title + "." + template.downcase), "w") do |f|
        f.puts ERB.new(File.read(template_file(options[:variant]))).result(binding)
      end
    end
    
    def metadata
      @book && @book.metadata
    end
    
    def find_file(name)
      File.expand_path(Dir[File.join(CONTENT_ROOT, name + '*')].sort_by(&:length).first) rescue nil
    end
    
  end
end