class CreateAdministrators < ActiveRecord::Migration[5.1]
  def change
    create_table :administrators do |t|
      t.column  :admin, :boolean, null: false, default: false
      t.timestamps
    end

    add_reference :users, :administrator, foreign_key: true
  end
end
