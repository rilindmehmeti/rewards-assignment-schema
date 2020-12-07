module Core
  module RewardsSystem
    module Presenter
      class CalculatedPoints < Default
        def to_h
          result = {}
          model.calculate_rewards
          customers_with_positive_values = model.customers.values.select { |customer| customer.points.positive? }
          customers_with_positive_values.each do |customer|
            result[customer.identifier] = customer.points
          end
          result
        end
      end
    end
  end
end