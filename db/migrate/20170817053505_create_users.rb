class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.timestamps
      t.string     :kind
      t.string     :email, null: false, default: ""
      t.string     :name
      t.string     :phone
      t.string     :password_digest
      t.string     :token
    end
    add_index :users, :token, unique: true
    add_index :users, :kind
  end
end
