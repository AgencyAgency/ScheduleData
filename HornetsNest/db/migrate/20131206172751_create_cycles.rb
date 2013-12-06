class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.integer :name

      t.timestamps
    end
  end
end
