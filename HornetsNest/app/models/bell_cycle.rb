class BellCycle < ActiveRecord::Base
  belongs_to :bell
  belongs_to :cycle
  has_many :periods
end