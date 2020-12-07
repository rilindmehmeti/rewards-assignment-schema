require 'rails_helper'
require 'shared_context/valid_input'

describe Core::RewardsSystem::Presenter::CalculatedPoints do
  include_context 'valid_input_data'
  let(:rewards_schema) {Core::RewardsSystem::RewardsSchema.new(input_data)}
  let(:presenter) { described_class.new(rewards_schema) }
  let(:expected_result) { {A: 1.75, B: 1.5, C: 1.0} }

  it 'should present data with right calculations' do
    expect(presenter.to_h).to eq expected_result.with_indifferent_access
  end
end