class Period < ActiveRecord::Base
  has_many :bell_cycle_periods

  class << self
    def find_or_create_by_name name
      match = find_all_by_name name
      period = nil
      if match.blank?
        period = create name: name
      elsif match.size > 1
        raise "Wrong number of periods found: #{name}"
      else
        period = match.first
      end
      return period
    end
  end
end
