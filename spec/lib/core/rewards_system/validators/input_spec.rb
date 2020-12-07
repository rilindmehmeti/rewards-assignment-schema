require 'rails_helper'
require 'shared_context/valid_input'

describe Core::RewardsSystem::Validators::Input do
  include_context 'valid_input_data'
  let(:validator) { described_class.new(input_data) }
  let(:validation_result) { true }

  shared_examples 'input_validator' do
    it 'should have expected result for valid?' do
      expect(validator.valid?).to eq validation_result
    end
  end


  describe '.valid?' do
    let(:errors) { validator.errors }

    context 'when input is valid' do
      include_examples 'input_validator'
    end

    context 'when input is invalid' do
      let(:validation_result) { false }

      context 'when input is empty' do
        let(:input_data) { nil }
        include_examples 'input_validator'

        it 'should have input error' do
          expect(validator).to_not be_valid
          expect(errors[:input_data].count).to eq 1
        end
      end

      context 'when input has invalid format' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends B hello
          INPUT_DATA
        }

        include_examples 'input_validator'

        it 'should have input error' do
          expect(validator).to_not be_valid
          expect(errors[:input_data].count).to eq 1
        end
      end

      context 'when having date is not in the first position' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-40 09:41 A recommends B
          INPUT_DATA
        }
        include_examples 'input_validator'

        it 'should have date_times error' do
          expect(validator).to_not be_valid
          expect(errors[:date_times].count).to eq 1
        end
      end

      context 'when inviting himself' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends C
          2018-06-12 09:41 C accepts
          2018-06-12 09:41 C recommends C
          INPUT_DATA
        }

        it 'should have actions error' do
          expect(validator).to_not be_valid
          expect(errors[:actions].count).to eq 1
        end
      end

      context 'when inviting without accepting' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends C         
          2018-06-12 09:41 C recommends D
          INPUT_DATA
        }

        it 'should have actions error' do
          expect(validator).to_not be_valid
          expect(errors[:actions].count).to eq 1
        end
      end

      context 'when accepts twice' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends C         
          2018-06-12 09:41 C accepts
          2018-06-12 09:41 C accepts
          INPUT_DATA
        }

        it 'should have actions error' do
          expect(validator).to_not be_valid
          expect(errors[:actions].count).to eq 1
        end
      end

      context 'when action is not allowed' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-12 09:41 A greets C
          INPUT_DATA
        }

        it 'should have actions error' do
          expect(validator).to_not be_valid
          expect(errors[:actions].count).to eq 1
        end
      end

      context 'when timeline is not right' do
        let(:input_data) {
          <<-INPUT_DATA
          2018-06-12 09:41 A recommends B
          2018-06-14 09:41 B accepts
          2018-06-16 09:41 B recommends C
          2018-06-17 09:41 C accepts
          2018-06-27 09:41 C recommends D
          2018-06-23 09:41 B recommends D
          2018-06-25 09:41 D accepts
          INPUT_DATA
        }

        it 'should have date_times error' do
          expect(validator).to_not be_valid
          expect(errors[:date_times].count).to eq 1
        end
      end

    end
  end

end