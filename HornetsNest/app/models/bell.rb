class Bell < ActiveRecord::Base
  has_many :bell_cycles
  has_many :cycles, through: :bell_cycles
end
