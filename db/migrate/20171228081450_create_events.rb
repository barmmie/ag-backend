class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :artist
      t.jsonb :overrides

      t.timestamps
    end
  end
end
