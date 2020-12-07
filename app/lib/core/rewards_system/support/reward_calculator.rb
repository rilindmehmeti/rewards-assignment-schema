module Core
  module RewardsSystem
    module Support
      module RewardCalculator
        module_function
        REWARD = (1 / 2.to_f).freeze

        def calculate_points(level)
          REWARD**level
        end
      end
    end
  end
end