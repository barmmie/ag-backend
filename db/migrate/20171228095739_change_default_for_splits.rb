class ChangeDefaultForSplits < ActiveRecord::Migration[5.0]
  def change
    change_column :tickets, :splits, :json, default: []
  end
end
