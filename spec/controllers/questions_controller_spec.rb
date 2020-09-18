require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # этап получения(подготовки) данных
  # способ задавать начальные данные через такие методы
  # метод let создаст метод questions который принимает блок и все это кэширует
  # let! - выполнит всю работу по созданию данных и помещения их в объект массива перед запуска каждого из тестов
  # let(:questions) { create_list(:question, 3) }
  let(:author) { create(:author) }
  let(:question) { create(:question, user: author) }
  let(:user) { create(:user) }
  let(:question2) { create(:question, user: user) }

  # используем созданный нами хелпер login
  before { login(author) }
  
  describe 'POST #create' do
    # context является элиfсом describe
    # describe используем для описания некой функциональности, context а контекст некие условия вариаций внутри describe
    context 'whith valid attributes' do
      it 'save a new question in the database' do
        # count = Question.count

        # # post :create, params: { question: { title: '123', body: '123' } }
        # # Используем фабрику для заполнения параметров
        # post :create, params: { question: attributes_for(:question) }

        # expect(Question.count).to eq count + 1

        # можно сократить вышеуказанный код. сначала выполняется часть change... а затем то, что до to и идет сравнение
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { id: question }
        expect(response).to redirect_to question
      end
    end

    context 'whith invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'whith valid attributes' do
      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        # reload обновит наш объект теми данными которые есть в БД
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'whith invalid attributes' do
      # этап выполнит код перед запуском каждого из тестов
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      # этапы проверки результата:
      it 'does not change question' do
        question.reload

        # чтобы не получился ложноположительный тест, возьмемм вручную данные из фабрики MyString и MyText и укажем в явном виде
        expect(question.title).to eq question.title
        expect(question.body).to eq 'MyText'
      end

      it 'render update view' do
        expect(response).to render_template :update
      end
    end

    context 'Only the author can update his question' do
      before { sign_in(create(:user)) }

      it 'question body has not changed' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new question' }, format: :js }
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new question'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author of the question' do
      let!(:question) { create(:question, user: author) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Not the author of the question' do
      let!(:question) { create(:question) }

      it 'Question is not deleted' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to_not redirect_to questions_path
      end
    end
  end

  describe 'POST #voteup' do
    context 'User tries to create a new up vote to a question' do
      it 'creates a new voice without being the author of the question' do
        expect { post :voteup, params: { id: question2.id }, format: :json }.to change(question2.votes, :count).by(1)
      end

      it 'does not create a new voice by being the author of the question' do
        expect { post :voteup, params: { id: question }, format: :json }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'POST #votedown' do
    context 'User tries to create a new down vote to a question' do
      it 'creates a new voice without being the author of the question' do
        expect { post :votedown, params: { id: question2 }, format: :json }.to change(question2.votes, :count).by(1)
      end

      it 'does not create a new voice by being the author of the question' do
        expect { post :votedown, params: { id: question }, format: :json }.to_not change(question.votes, :count)
      end
    end
  end
end
