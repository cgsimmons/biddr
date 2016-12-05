class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.references :user, foreign_key: true
      t.references :auction, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
