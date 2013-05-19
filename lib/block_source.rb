require "block_source/version"
require 'ripper'
require 'plock'
require 'backports/2.0.0/enumerable/lazy'

module BlockSource
  class Parser < Ripper::Filter
    def on_default event, token, data
      p { [token, event] }
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

if __FILE__ == $PROGRAM_NAME
  source_to_be_parsed = <<-EOF
  p do
    lam = lambda { 1 + 2 }
    pro = proc do
      puts 'hello, world'
    end
  end
  EOF
  b = BlockSource::Parser.new source_to_be_parsed
  parsed_source = b.parse( '' )
  puts parsed_source
  p parsed_source == source_to_be_parsed
end
