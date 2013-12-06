class Cycle < ActiveRecord::Base
  has_many :bell_cycles
  has_many :bells, through: :bell_cycles
end
