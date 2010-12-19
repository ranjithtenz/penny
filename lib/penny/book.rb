module Penny
  class Book
    attr_accessor :metadata, :filelist
    include Penny::Tools
    
    # Create a book object
    def initialize(&block)
      @metadata = default_metadata
      @filelist = []
      
      instance_eval &block
      
      raise "No title" unless @metadata[:title]
      
      unless @metadata[:identifier]
        # Unique identifier is the title + edition
        @metadata[:identifier] = "#{metadata[:title].gsub(/[^\w]/, '')}-#{@metadata[:edition]}"
      end
    end
    
    # Create or return the contents tree for a book
    def contents(&block)
      if block_given?
        @contents = Contents.new(block)
      else
        @contents.tree
      end
    end
    
    # Magic to set metadata info in a block passed when initializing the book
    def method_missing(m, *args)
      @metadata[m] = args.length == 1 ? args.first : args
    end
    
    # Build a book using a specific builder
    def build(builder, options = {}, &block)
      raise "No contents" unless contents
      @options = options
      @builder = builder.new(self, options)
      
      @builder.build
      
      if block_given?
        instance_exec self, &block
        clear_tmp unless options[:keep_tmp]
      end
    end
    
    # Return the "safe" title of a book for use in filenames - also includes the variant name, if present
    def safe_title
      @metadata[:title].gsub(/[^\w]/, '') + (@options[:variant] ? "." + @options[:variant] : '')
    end
    
    # Render a PDF
    def render_pdf
      `prince tmp/#{safe_title}.html -o pkg/#{safe_title}.pdf`
    end
        
    private
    def default_metadata
      {
        :year => Time.now.year,
        :edition => 1
      }
    end
    
    # A way of storing a contents tree - slightly overkill for now but could be useful to extend later
    class Contents
      attr_reader :tree

      def initialize(tree)
        @tree = []
        
        # Keep track of various state info about the contents tree while building it
        @state = { :chapter => 1, :appendix => "A", :counters => {} }
        instance_eval &tree
      end

      # Return an inspection of the tree, our main form of data in a Contents object
      def inspect
        @tree.inspect
      end
      
      def method_missing(m, *args)
        @saved ||= []
        
        # If there's nesting of the contents info going on, yield to it and save the info for later use
        if block_given?
          @saved << [m, args.first]
          yield
          @saved.pop
        else
          # Is this a top level setting? If so, easy peasy
          if @saved.empty?
            item_header = [m]
          else
            # If this setting is nested note all of the previous branches in the tree
            item_header = [m] + @saved.dup.map(&:first).reverse
            
            # Collect together arguments from previous branches
            other_args = @saved.dup.map { |h| h[1] }
          end

          # Blend arguments from previous branches with later ones giving priority to more "senior" arguments
          extra_args = {}
        
          other_args.each do |e|
            extra_args.merge!(e) if e.is_a?(Hash)
          end if other_args

          # Take the extra args and blend them in, giving seniority to more "senior" arguments
          args = args.first.merge(extra_args)

          # If there are extra types (a bit like CSS classes) to be added, get them out and put them into the header
          if args[:types]
            item_header += args[:types].split(/\s+/).map { |t| t.to_sym }
            args.delete(:types)
          end

          # Build the item hash, merging in the arguments
          item = { :types => item_header }.merge(args)

          # Deal with general item counters
          @state[:counters][item_header.last] ||= 1
          item[:counter] = @state[:counters][item_header.last]
          @state[:counters][item_header.last] += 1

          # If we're dealing with a chapter, give it an ID if conditions are right
          if item_header.include?(:chapter)

            # If it's not frontmatter or appendix, give it a regular chapter number
            unless item_header.include?(:frontmatter) || item_header.include?(:appendix)
              item[:chapter] = @state[:chapter]
              @state[:chapter] += 1
            end

            # If it's an appendix chapter, use the appendix naming scheme instead
            if item_header.include?(:appendix)
              item[:chapter] = @state[:appendix].dup
              @state[:appendix].succ!
            end          
          end
          
          # Find full filename for name
          if item[:name]
            item[:content_file] = File.expand_path(Dir[File.join(CONTENT_ROOT, item[:name] + '*')].sort_by(&:length).first) rescue nil
          end

          # Add the item to the contents tree
          @tree << item
        end
      end
    end
  end
end