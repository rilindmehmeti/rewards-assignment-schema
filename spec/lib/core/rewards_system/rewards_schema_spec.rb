require 'rails_helper'
require 'shared_context/valid_input'

describe Core::RewardsSystem::RewardsSchema do
  include_context 'valid_input_data'
  let(:object) {described_class.new(input_data)}

  describe '.valid?' do
    context 'when we have valid input' do
      it 'should be valid' do
        expect(object.valid?).to be_truthy
      end
    end

    context 'when input is invalid' do
      let(:input_data) {
        <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
          2018-06-14 09:41 B accepts
          2018-06-16 09:41 B recommends C
          2018-06-17 09:41 C accepts
          2018-06-19 09:41 C recommends D
          2018-06-23 09:41 B recommends D
          2018-06-25 09:41 D accepts
        INPUT_DATA
      }
      it 'should not be valid' do
        expect(object.valid?).to be_falsey
      end
    end
  end

  describe '.size' do
    it 'should have the same size as customers' do
      expect(object.size).to eq 4
    end
  end

end