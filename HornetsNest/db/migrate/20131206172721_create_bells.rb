class CreateBells < ActiveRecord::Migration
  def change
    create_table :bells do |t|
      t.string :name

      t.timestamps
    end
  end
end
