require 'erb'
require 'yaml'
require 'find'
require 'fileutils'
require 'penny/tools'
require 'penny/book'
require 'penny/builder'
require 'penny/builders/html'
require 'penny/builders/epub'

# Set various useful directory constants
    BOOK_ROOT = File.dirname(File.expand_path($0))
 CONTENT_ROOT = File.join(BOOK_ROOT, "content")
  ASSETS_ROOT = File.join(CONTENT_ROOT, "assets")
     TEMP_DIR = File.join(BOOK_ROOT, "tmp")
      PKG_DIR = File.join(BOOK_ROOT, "pkg")