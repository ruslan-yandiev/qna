class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %i[index show]
  before_action :links_to_question, only: :new
  before_action :links_to_answer, only: :show

  expose :questions, -> { Question.all }
  expose :question

  # чтобы уменьшить количество запросов к базе при добавлении множества файлов, добавим скоуп (with_attached_files) - подгрузим вопрос сразу с файлами. решение проблемы n + 1
  expose :load_question, -> { Question.with_attached_files.find(params[:id]) }

  def create
    question.user = current_user

    if question.save
      redirect_to question_path(question), notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return head :forbidden if !current_user&.author?(question)
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

  # .build часто используют с ассоциацией вместо new чтобы показать, что создается именно полиморфная ассоциация
  def links_to_question
    question.links.new
  end

  def links_to_answer
    @answer = question.answers.new
    @answer.links.build
  end

  def question_params
    # links_attributes: передадим в качестве одобренных параметров для внесения в базу параметры вложенной модели 
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url id _destroy])
  end
end
