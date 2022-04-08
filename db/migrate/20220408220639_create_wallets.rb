class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :coins, precision: 10, scale: 2

      t.timestamps
    end
  end
end
