class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.string :phone, index: { unique: true }, null: false

      t.boolean :verified, null: false, default: false

      t.timestamps
    end
  end
end
