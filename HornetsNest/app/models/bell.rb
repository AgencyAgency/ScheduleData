class Bell < ActiveRecord::Base
  has_many :bell_cycles
  has_many :cycles, through: :bell_cycles

  class << self
    def find_or_create_by_name name
      match = find_all_by_name name
      bell = nil
      if match.blank?
        bell = create name: name
      elsif match.size > 1
        raise "Wrong number of bells found: #{name}"
      else
        bell = match.first
      end
      return bell
    end
  end
end
