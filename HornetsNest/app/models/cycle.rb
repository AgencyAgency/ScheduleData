class Cycle < ActiveRecord::Base
  has_many :bell_cycles
  has_many :bells, through: :bell_cycles

  class << self
    def find_or_create_by_name name
      match = find_all_by_name name
      cycle = nil
      if match.blank?
        cycle = create name: name
      elsif match.size > 1
        raise "Wrong number of cycles found: #{name}"
      else
        cycle = match.first
      end
      return cycle
    end
  end
end
