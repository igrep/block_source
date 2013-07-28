require "block_source/version"
require 'ripper/filter'
require 'stringio'
require 'plock'

module BlockSource
  class Parser < Ripper::Filter

    TOKEN_BEGINNING_CODE_BLOCK = %w/do/.freeze
    TOKEN_CLOSING_CODE_BLOCK = %w/end/.freeze

    def on_default _event, token, s
      case token
      when *TOKEN_BEGINNING_CODE_BLOCK
        s.block_source << token
        s.surrounding_blocks.push token
      when *TOKEN_CLOSING_CODE_BLOCK
        s.block_source << token
        s.surrounding_blocks.pop
      else
        s.block_source << token unless s.surrounding_blocks.empty?
      end
      s
    end

    def parse # override to hide the argument
      state_after_parsed = super( State.new )
      state_after_parsed.block_source
    end

    class State
      attr_accessor :block_source, :surrounding_blocks
      def initialize block_source = '', surrounding_blocks = []
        @block_source = block_source
        @surrounding_blocks = surrounding_blocks
      end
    end

    class << self
      def parse io_or_string, path, line_num
        io = io_or_string.is_a?( String ) ? StringIO.new( io_or_string ) : io_or_string
        skip_lines_until io, line_num
        self.new( io, path, line_num ).parse
      end

      def skip_lines_until io, line_num
        ( line_num - 1 ).times { io.readline }
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
