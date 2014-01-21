class Bell < ActiveRecord::Base
  has_many :bell_cycles
  has_many :cycles, through: :bell_cycles

  def school_days
    bell_cycles.inject([]) { |mem, bell_cycle| mem.concat bell_cycle.school_days }
  end

  class << self

    def school_days_for_bell_name bell_name
      bell = find_by_name bell_name
      bell.school_days
    end

    def school_days_for_bell_names *bell_names_array
      bell_names_array.flatten.inject([]) do |mem, bell_name|
        mem.concat(school_days_for_bell_name(bell_name))
      end
    end

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
