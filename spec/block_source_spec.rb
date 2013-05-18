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

  describe described_class::Parser do
    let( :described_instance ) { described_class.new target_string }
    describe '#parse' do
      let( :target_string ){
        %Q{
          a = 1
          b = proc do
            puts a
          end
          b.call
        }
      }
      subject { described_instance.parse }
      it { should eq expected_source_code }
    end
  end
end
