class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.date :birthday, null: false
      t.integer :sex, default: 0, null: false # (0.未設定, 1.mon, 2.woman)

      t.timestamps
    end
  end
end
