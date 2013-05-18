require 'block_source'

describe BlockSource do
  describe '.block_source' do
    context 'when processing the only do-end block in a line' do
      subject do # here must be newline so far!
        proc_obj = proc do puts "hello, world" end
        BlockSource.block_source proc_obj
      end
      it { should eq 'do puts "hello, world" end' }
    end
  end
end
