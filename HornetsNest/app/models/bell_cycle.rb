class BellCycle < ActiveRecord::Base
  belongs_to :bell
  belongs_to :cycle

  has_many :school_days
  has_many :bell_cycle_periods
end
