class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :card_number
      t.float :value
      t.date :due_date
      t.integer :cvv

      t.timestamps
    end
  end
end
