require 'eeepub'

module Penny
  class EPUB < Builder
    def build
      respond_to?(:before_build) && before_build
      
      nav = []
      
      @book.build(HTML, variant: 'epub', keep_tmp: true) do |b|
        sass
        copy_assets("*.css")
        b.contents.each do |item|
          nav << { label: item[:title], content: item[:rendered_file] }
        end
      end
      
      # Necessary due to EeePub's instance_eval magic
      book = @book

      epub = EeePub.make do
        title book.metadata[:title]
        creator book.metadata[:author]
        publisher book.metadata[:publisher]
        date book.metadata[:date]
        identifier book.metadata[:identifier], :scheme => 'URL'
        uid book.metadata[:identifier]

        files book.all_files

        nav nav
      end

      epub.save(PKG_DIR + "/" + @book.safe_title)
      
      respond_to?(:after_build) && after_build
    end
    
 
  end
end