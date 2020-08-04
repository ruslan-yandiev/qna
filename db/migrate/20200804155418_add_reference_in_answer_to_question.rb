class AddReferenceInAnswerToQuestion < ActiveRecord::Migration[6.0]
  def change
  	add_reference :answers, :question, index: true, null: false, foreign_key: true
  end
end
