require 'helper'

class TestBook < Test::Unit::TestCase
  def test_builder_template_extension
    assert_equal "html", HTML.new(SIMPLE_VALID_BOOK).template
  end
  
  def test_setting_template_extension
    b = HTML.new(SIMPLE_VALID_BOOK)
    b.template("pdf")
    assert_equal "pdf", b.template
  end
  
  def test_builder_template_file_generation
    assert HTML.new(SIMPLE_VALID_BOOK).template_file("test") =~ /template\.test\.html$/
  end
  
  # TODO: Test helpers, package_build and render_item
end