class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      # t.references :question как вариант можем указать belongs_to для создании внешнего ключа связи
      # не забываем установить foreign_key: true для контроля целостности на уровне БД
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
