require 'rails_helper'
require 'shared_context/valid_input'

describe CalculateRewardsSchemaPoints do
  include_context 'valid_input_data'
  let(:params) { {input_data: input_data} }
  let(:result) { described_class.call(params) }
  let(:expected_result) { {status: :ok, data: [
      {name: 'A', recommended_by: nil, points: 0},
      {name: 'B', recommended_by: 'A', points: 0},
      {name: 'C', recommended_by: 'B', points: 0},
      {name: 'D', recommended_by: 'C', points: 0}
  ]} }

  describe '.call' do
    context 'with default params' do
      it { expect(result).to eql expected_result }
    end

    context 'with CalculatedPoints as presenter' do
      let(:params) { {input_data: input_data, presenter: 'Core::RewardsSystem::Presenter::CalculatedPoints'} }
      let(:expected_result) { {status: :ok, data: {A: 1.75, B: 1.5, C: 1.0}.with_indifferent_access} }
      it { expect(result).to eql expected_result }
    end

    context 'when invalid data' do
      let(:params) { {input_data: nil} }
      let(:result) { described_class.call(params) }
      let(:expected_result) { {status: :unprocessable_entity, data: ["Input data can't be blank"]} }
      it { expect(result).to eql expected_result }
    end
  end

end