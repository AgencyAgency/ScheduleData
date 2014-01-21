class BellCyclePeriod < ActiveRecord::Base
  belongs_to :bell_cycle
  belongs_to :period
end
