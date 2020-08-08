class AnswersController < ApplicationController
  
  # гем 'decent_exposure' позволяет и в такой форме получать параметры
  expose :question, id: :question_id
  expose :answer, -> { question.answers }

  def create
    @answer = answer.new(answer_params)

    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
