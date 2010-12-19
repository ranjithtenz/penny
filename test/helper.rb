require 'test/unit'
begin; require 'turn'; rescue LoadError; end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'penny'

class Test::Unit::TestCase
  include Penny
  
  SIMPLE_VALID_BOOK = Book.new do
    title "My title"

    contents do        
      frontmatter do
        page name: 'test'
      end

      chapter name: 'test2'
    end
  end
end