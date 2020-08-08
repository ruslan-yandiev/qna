class AnswersController < ApplicationController
  
  # гем 'decent_exposure' позволяет и в такой форме получать параметры
  expose :question, id: :question_id
  expose :answers, -> { question.answers }
  expose :answer

  def create
    @answer = answers.new(answer_params)

    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer_path(answer)
    else
      render :edit
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
