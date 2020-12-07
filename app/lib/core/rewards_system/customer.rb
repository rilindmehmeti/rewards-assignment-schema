module Core
  module RewardsSystem
    class Customer
      attr_accessor :identifier, :recommended_by, :accepted, :points

      def initialize(identifier, recommended_by, accepted = false)
        @identifier = identifier
        @recommended_by = recommended_by
        @accepted = accepted
        @points = 0
      end

      def add_points(_points)
        self.points = points + _points
      end

      def accept_invitation
        self.accepted = true
      end

      def validate_recommended_by_points(level = 0)
        return if skip_point_validation_criteria
        points = Support::RewardCalculator.calculate_points(level)
        return unless points.positive?
        recommended_by.add_points(points)
        recommended_by.validate_recommended_by_points(level + 1)
      end

      def skip_point_validation_criteria
        !accepted
        recommended_by.nil?
      end

      def to_h
        {name: identifier, recommended_by: recommended_by.try(:identifier), points: points}
      end

    end
  end
end