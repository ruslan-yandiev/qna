class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.references :user, foreign_key: true
      t.string :title, present: true, null: false
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
