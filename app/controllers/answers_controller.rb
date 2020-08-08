class AnswersController < ApplicationController

  expose :answer, -> { find_question.answers }

  def create
    @answer = answer.new(answer_params)
    @answer.save
    redirect_to answer_path(@answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
