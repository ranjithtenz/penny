Penny - Flexible E-Book Generation
==================================

Penny is an experimental, flexible, multi-format (source and destination)
e-book generator.

Requirements
-------------

  Ruby 1.9.2+ (uses lots of Ruby 1.9 specific stuff so don't even try with 1.8 :-))
  eeepub (for EPUB generation)
  kramdown
  
Bundler will install the gems for you, if you like.

Install
-------

gem install penny
bundle

Explanation
-----------

Penny is currently tailored for taking multiple files written in Markdown and
turning them into various forms of HTML export for passing to PDF, ePub,
Mobi and various other generators, but has been created in a modular
fashion to make it easy to add more options later.

As of time of writing, Penny is HIGHLY EXPERIMENTAL and I do not
recommend its use by third parties, unless they are both brave, ready
to deal with Penny's shortcomings, and not expecting any support. I will,
of course, answer all reasonable questions though :-)

Usage
-----

This is only to give an illustration. Some proper usage info will come in time:

    require 'penny'

    # Define a book
    book = Penny::Book.new do
      title         "My Awesome Book"
      author        "Peter Cooper"
      email         "whatever@whatever.com"
      tagline       "Waka waka waka"
      frontcover    "misc/cover.jpg"
      backcover     "misc/backcover.jpg"
      
      contents do
        frontmatter do
          page name: 'innertitle', types: 'titlepage right'
          page name: 'imprint', types: 'left imprint'
          chapter name: 'acknowledgements'
          chapter name: 'preface'
        end
        
        chapters do
          part title: "The Good Stuff" do
            chapter name: 'this'
            chapter name: 'that'
            chapter name: 'theother'
          end
          
          part title: "The Bad Stuff" do
            chapter name: 'thebad'
            chapter name: 'theugly'
          end
        end
        
        appendix do
          chapter name: 'resources'
        end
      end
    end
  
    # Build a book with the HTML builder then do extra stuff like render a SASS
    # file and render a PDF using Prince (just use backticks and call your own
    # stuff if you want to do other things..)
    
    book.build(Penny::HTML) do
      sass              
      render_pdf        
    end
    
    
    # Build a different variant using a different final HTML template (template.variant.html)
    # that uses an extra CSS file to tweak settings. We copy this over with copy_assets
    # in this case.
    
    book.build(Penny::HTML, variant: 'landscape') do
      sass
      copy_assets("*.css")                        
      render_pdf                              
    end
    
    
    # Ugly example included for completeness
    # I no longer create .mobi or .epub files this way but it shows how you can "finish the job"
    # using other apps you have installed such as Amazon's 'kindlegen'
    
    book.build(Penny::HTML, variant: 'kindle') do |b|
      `/Users/peter/Misc/kindlegen/kindlegen tmp/#{b.safe_title}.html -o #{b.safe_title}.mobi`
      `cp tmp/#{b.safe_title}.mobi #{PKG_DIR}`
      `ebook-convert pkg/#{b.safe_title}.mobi #{PKG_DIR}/#{b.safe_title}.epub`
    end                                 

Tests
-----

There *are* tests and they run nicely with "rake test". Coverage isn't 100%
but the main snafus should be covered. E-book building is really a process
that would benefit from *integration* tests and that's on my TODO.

License
-------

MIT license. Copyright (c) 2010 Peter Cooper.