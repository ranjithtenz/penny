require 'fileutils'

module Penny
  module Tools    
    def sass(from = 'book.scss', to = 'book.css', options = '--scss')
      `sass --no-cache #{options} #{CONTENT_ROOT}/#{from} #{TEMP_DIR}/#{to}`
    end
    
    def clear_tmp
      FileUtils.rm_f(Dir["#{TEMP_DIR}/*"])
    end
    
    def copy_assets(what = "*.css")
      FileUtils.cp(Dir["#{CONTENT_ROOT}/#{what}"], TEMP_DIR)
    end
  end
end