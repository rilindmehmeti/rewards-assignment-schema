require 'rails_helper'

describe Core::RewardsSystem::Support::RewardCalculator do

  def reward_formula(level)
    (1 / 2.to_f) ** level
  end

  def test_point_calculation(level, result)
    expect(described_class.calculate_points(level)).to eq result
  end

  describe '.calculate_points' do
    let(:cases) {[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}
    it 'should test different cases for level' do
      cases.each do |level|
        test_point_calculation(level, reward_formula(level))
      end
    end
  end
end