class CreateBellCyclePeriods < ActiveRecord::Migration
  def change
    create_table :bell_cycle_periods do |t|
      t.time :start_time
      t.time :end_time
      t.references :bell_cycle, index: true
      t.references :period, index: true

      t.timestamps
    end
  end
end
