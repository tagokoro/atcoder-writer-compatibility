class CreateContests < ActiveRecord::Migration[7.0]
  def change
    create_table :contests do |t|
      t.integer :contest_id
      t.string :contest_type

      t.timestamps
    end
  end
end
