class BellCycle < ActiveRecord::Base
  belongs_to :bell
  belongs_to :cycle

  has_many :school_days
  has_many :bell_cycle_periods

  class << self
    def find_or_create_by_bell_and_cycle_names(bell_name, cycle_name)
      bell = Bell.find_or_create_by_name bell_name
      cycle = Cycle.find_or_create_by_name cycle_name
      match = self.joins(:bell, :cycle)
        .where('bells.name' => bell.name, 'cycles.name' => cycle.name)

      bell_cycle = nil
      if match.blank?
        bell_cycle = BellCycle.create(bell: bell, cycle: cycle)
      elsif match.size > 1
        raise "Error! Found too many BellCycles (#{match.size}) for #{bell.name} : #{cycle.name} -> #{match}"
      else
        bell_cycle = match.first
      end
      return bell_cycle
    end
  end
end
