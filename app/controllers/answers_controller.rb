class AnswersController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]
  
  # гем 'decent_exposure' позволяет и в такой форме получать параметры
  expose :question, id: :question_id
  expose :answers, -> { question.answers }
  expose :answer

  def create
    @answer = answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(question), alert: 'Your answer succesfully created'
    else
      # flash.now[:notice] = "Body can't be blank"
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer_path(answer)
    else
      render :edit
    end
  end

  def destroy
    if current_user&.author?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Answer succesfully deleted'
    else
      redirect_to question, alert: 'You cannot delete this answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
