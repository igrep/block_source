require "block_source/version"
require 'ripper'
require 'plock'

module BlockSource
  class Parser < Ripper::Filter
    def on_default event, token, data
      data << token
    end

    def parse
      super ''
    end
  end

  class << self
    def block_source proc_obj
      path, line_num = proc_obj.source_location
      File.open( path ) do|f|
        self::Parser.new( f, f.path, line_num ).parse ''
      end
    end
  end
end
