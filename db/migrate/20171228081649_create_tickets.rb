class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :event, foreign_key: true, index: true
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity
      t.string :source
      t.json :splits

      t.timestamps
    end
  end
end
