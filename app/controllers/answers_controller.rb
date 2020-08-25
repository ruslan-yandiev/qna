class AnswersController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]
  
  # гем 'decent_exposure' позволяет и в такой форме получать параметры, и можем не использовать before_action
  expose :question, id: :question_id
  expose :answers, -> { question.answers }
  expose :answer

  def create
    # @answer = answers.new(answer_params)
    # @answer.user = current_user
    # @answer.save
    @answer = answers.create(answer_params.merge(user: current_user))
  end

  def update
    # Если текущий пользователь не автор ответа, то вернем ошибку со статусом 403
    return head :forbidden if !current_user&.author?(answer)
    answer.update(answer_params)
  end

  def destroy
    return head :forbidden if !current_user&.author?(answer)
    answer.destroy
  end

  def best
    return head :forbidden if !current_user&.author?(answer)
    answer.set_best_value
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
