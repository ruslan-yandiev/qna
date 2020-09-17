class AnswersController < ApplicationController
  include Voted
  
  # гем 'decent_exposure' позволяет и в такой форме получать параметры, и можем не использовать before_action
  expose :question, id: :question_id
  expose :answers, -> { question.answers }
  expose :answer

  def create
    # @answer = answers.create(answer_params.merge(user: current_user))
    @answer = answers.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        # format.html { render @answer }

        format.json { render json: @answer }
      else
        # чтобы передача параметра для обработки его во вьюхе сработало из контроллера передадим его через хэш locals, изменим статус ответа на 422 для любого невалидного объекта
        # format.html { render partial: 'shared/errors', locals: { resource: @answer }, status: 422 } # unprocessable_entity почему то не работает

        format.json { render json: @answer.errors.full_messages, status: 422 }
      end
    end
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
    return head :forbidden if !current_user&.author?(answer.question)
    answer.set_best_value
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url id _destroy])
  end
end
