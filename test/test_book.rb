require 'helper'

class TestBook < Test::Unit::TestCase
  def test_book_cant_be_created_without_block
    assert_raise ArgumentError do
      book = Book.new
    end
  end
  
  def test_basic_book_can_be_created
    book = Book.new do
      title "My book"
    end
    assert_equal Book, book.class
  end
  
  def test_book_metadata_is_saved
    book = Book.new do
      title "My book"
      author "Peter Cooper"
    end
    
    assert_equal "My book", book.metadata[:title]
    assert_equal "Peter Cooper", book.metadata[:author]
  end
  
  def test_default_book_metadata_is_used
    book = Book.new do
      title "My book"
      author "Peter Cooper"
    end

    assert_equal Time.now.year, book.metadata[:year]
    assert_equal 1, book.metadata[:edition]
  end
  
  def test_book_without_title_is_invalid
    assert_raise RuntimeError do
      book = Book.new do
        author "Peter Cooper"
      end
    end
  end
  
  def test_book_contents_are_created
    assert_equal [{:types=>[:page, :frontmatter],
                   :name=>"test",
                   :counter=>1,
                   :content_file=>nil},
                  {:types=>[:chapter],
                   :name=>"test2",
                   :counter=>1,
                   :chapter=>1,
                   :content_file=>nil}], SIMPLE_VALID_BOOK.contents
    
  end
end