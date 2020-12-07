require 'rails_helper'
require 'shared_context/valid_input'

describe Core::RewardsSystem::Presenter::Default do
  include_context 'valid_input_data'
  let(:rewards_schema) { Core::RewardsSystem::RewardsSchema.new(input_data) }
  let(:presented) { described_class.new(rewards_schema) }
  let(:expected_result) {[
      {name: 'A', recommended_by: nil, points: 0},
      {name: 'B', recommended_by: 'A', points: 0},
      {name: 'C', recommended_by: 'B', points: 0},
      {name: 'D', recommended_by: 'C', points: 0}
  ]}

  it { expect(presented.to_h).to eql expected_result }
end