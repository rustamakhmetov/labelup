class AddPolymorphicFieldToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :roleable, polymorphic: true, index: true
  end
end
