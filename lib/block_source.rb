require "block_source/version"
require 'ripper/filter'
require 'plock'

module BlockSource
  class Parser < Ripper::Filter

    def on_kw ruby_keyword, state
    end

    def parse
      super ''
    end

    class State
      attr_accessor :block_source, :in_do
      def initialize block_source = '', in_do = false
        @block_source = block_source
        @in_do = in_do
      end
    end

    class << self
      def parse io_or_string, path, line_num
        self.new( io_or_string, path, line_num ).parse
      end
    end
  end

  class << self
    def block_source proc_obj
      path, line_num = proc_obj.source_location
      File.open( path ) do|f|
        self::Parser.parse( f, f.path, line_num )
      end
    end
  end
end
