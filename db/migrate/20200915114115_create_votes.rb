class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.integer :value, default: 0
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end
  end
end
