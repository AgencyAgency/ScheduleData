class CreateBellCycles < ActiveRecord::Migration
  def change
    create_table :bell_cycles do |t|
      t.references :bell, index: true
      t.references :cycle, index: true

      t.timestamps
    end
  end
end
