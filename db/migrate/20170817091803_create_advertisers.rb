class CreateAdvertisers < ActiveRecord::Migration[5.1]
  def change
    create_table :advertisers do |t|
      t.string :organization
      t.string :position
      t.timestamps
    end

    add_reference :users, :advertiser, foreign_key: true
  end
end
