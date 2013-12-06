class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name
      t.time :start_time
      t.time :end_time
      t.references :bell_cycle, index: true

      t.timestamps
    end
  end
end
