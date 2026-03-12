class CreateWriterContests < ActiveRecord::Migration[7.0]
  def change
    create_table :writer_contests do |t|
      t.references :writer, null: false, foreign_key: true
      t.references :contest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
