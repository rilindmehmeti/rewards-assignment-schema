module Core
  module RewardsSystem
    module Presenter
      class Default < ::Presenter::BasePresenter
        def to_h
          model.customers.values.map(&:to_h)
        end
      end
    end
  end
end