module Core
  module RewardsSystem
    module Validators
      class Input
        include ActiveModel::Validations
        VALID_ACTIONS = %w[recommends accepts].freeze
        ACTION_INDEX = 3
        ALLOWED_ROW_LENGTH = [4, 5].freeze

        attr_reader :input_data

        validates :input_data, presence: true
        validate :validate_input_format

        def initialize(input_data)
          @input_data = input_data.try(:strip)
          @invited = {}
          @accepted = {}
          @date_times = []
        end

        private

        def validate_input_format
          return if input_data.nil?
          input_data.each_line.each_with_index do |row, index|
            row.strip!
            position = index + 1
            validate_items_length(row, position)
            validate_date(row, position)
            validate_action(row, position)
          end
          validate_timeline
        end

        def validate_items_length(row, position)
          items_count = row.split.size
          return if ALLOWED_ROW_LENGTH.include?(items_count)
          errors.add(:input_data, "Line #{position} has undefined format!")
          notify_failure
        end

        def validate_date(row, position)
          begin
            date, time = row.split[0..1]
            @date_times << Parsers::Date.parse(date, time)
          rescue ArgumentError
            errors.add(:date_times, "Date Time format not correct in line #{position}")
            notify_failure
          end
        end

        def validate_action(row, position)
          date, time, customer_one, action, customer_two = row.split
          if VALID_ACTIONS.include?(action)
            validate_accepts(customer_one, position) if action == 'accepts'
            validate_recommends(customer_one, customer_two, position) if action == 'recommends'
          else
            errors.add(:actions, "Line #{position} has an invalid action!")
            notify_failure
          end
        end

        def validate_accepts(customer_one, position)
          if @accepted[customer_one] == 1
            errors.add(:actions, "Line #{position}, Customer acceptance is repeated more than once!")
            notify_failure
          end
          @accepted[customer_one], @invited[customer_one] = 1, nil
        end

        def validate_recommends(customer_one, customer_two, position)
          if customer_one == customer_two
            errors.add(:actions, "Line #{position}, customer can't invite himself")
            notify_failure
          elsif @invited[customer_one] == 1
            errors.add(:actions, "Line #{position}, customer has to be registered in order to be able to recommend!")
            notify_failure
          end
          @invited[customer_two] = 1
        end

        def validate_timeline
          return if @date_times.size < 2
          if @date_times != @date_times.sort
            errors.add(:date_times, 'Actions are not in order')
            notify_failure
          end
        end

        def notify_failure
          throw(:abort)
        end

      end
    end
  end
end