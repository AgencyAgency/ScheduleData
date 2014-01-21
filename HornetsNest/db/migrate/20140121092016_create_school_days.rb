class CreateSchoolDays < ActiveRecord::Migration
  def change
    create_table :school_days do |t|
      t.date :day
      t.references :bell_cycle, index: true

      t.timestamps
    end
  end
end
