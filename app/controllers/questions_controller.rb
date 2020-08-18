class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question

  def create
    question.user = current_user

    if question.save
      redirect_to question_path(question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return if !current_user&.author?(question)
    question.update(question_params)
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      redirect_to question, notice: 'Question succesfully deleted'
    else
      redirect_to question, alert: 'You cannot delete this question'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
