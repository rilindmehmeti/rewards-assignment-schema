module Core
  module RewardsSystem
    module Validators
      module Parsers
        module Date
          module_function

          def parse(date, time)
            DateTime.parse("#{date} #{time}").utc
          end
        end
      end
    end
  end
end