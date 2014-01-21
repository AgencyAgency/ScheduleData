class SchoolDay < ActiveRecord::Base
  belongs_to :bell_cycle

  class << self
    def find_or_create_by_bell_and_cycle_names_and_day(bell_name, cycle_name, string_day)
      bell_cycle = BellCycle.find_or_create_by_bell_and_cycle_names(bell_name, cycle_name)
      day = Date.parse(string_day)

      match = find_all_by_day day

      school_day = nil
      if match.blank?
        school_day = create(day: day, bell_cycle: bell_cycle)
      elsif match.size > 1
        raise "Error! Found too many school days (#{match.size}) for #{day}"
      else
        school_day = match.first
      end
      return school_day
    end
  end
end
