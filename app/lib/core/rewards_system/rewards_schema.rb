module Core
  module RewardsSystem
    class RewardsSchema
      attr_accessor :customers, :validator
      attr_reader :input_data

      delegate :size, to: :customers

      def initialize(input_data)
        @input_data = input_data
        @validator = Validators::Input.new(input_data)
        @customers = {}
        populate_costumers if valid?
      end

      def find(key)
        customers[key]
      end

      def add(key, value)
        customers[key] = value
      end

      def add_accepted_customer(identifier)
        customer = find(identifier)
        customer.accept_invitation and return unless customer.nil?
        add(identifier, Customer.new(identifier,nil, true ))
      end

      def add_recommended_customer(identifier, recommended_by_identifier)
        recommended_by_identifier
        inviter = find(identifier)
        if inviter.nil?
          inviter = Customer.new(identifier, nil , true)
          add(identifier, inviter)
        end
        add(recommended_by_identifier, Customer.new(recommended_by_identifier, inviter)) if find(recommended_by_identifier).nil?
      end

      def valid?
        @is_valid ||= validator.valid?
      end

      def calculate_rewards
        customers.values.each do |customer|
          customer.validate_recommended_by_points
        end
      end

      def errors
        @errors ||= validator.errors
      end

      private

      def populate_costumers
        input_data.each_line do |row|
          row.strip!
          next if row.nil?
          customer_one, action, customer_two = row.split[2..-1]
          action == 'accepts' ? add_accepted_customer(customer_one) : add_recommended_customer(customer_one, customer_two)
        end
      end

    end
  end
end