class RemoveUnusedFieldsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :administrator_id
    remove_column :users, :advertiser_id
    remove_column :users, :kind
  end
end
