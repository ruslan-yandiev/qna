require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
    # этап получения(подготовки) данных
    let(:question) { create(:question) }

  describe 'GET #index' do
    # способ задавать начальные данные через такие методы
    # метод let создаст метод questions который принимает блок и все это кэширует
    # let! - выполнит всю работу по созданию данных и помещения их в объект массива перед запуска каждого из тестов
    let(:questions) { create_list(:question, 3) }

    # выполнит код перед запуском каждого из тестов
    before { get :index }

    it 'populates an array of all questions' do
      # assigns позволит нам увидеть @questions инстанс переменную класса QuestionsController
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      # response эявляется объектом ответа
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    # этап действия
    before { get :show, params: { id: question } }

    # # этапы проверки результата:
    # it 'assigns the requested question to @question' do
    #   expect(assigns(:question)).to eq question
    # end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    # it 'assigns a new Question to @question' do
    #   expect(assigns(:question)).to be_a_new(Question)
    # end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    # it 'assigns the requested question to @question' do
    #   expect(assigns(:question)).to eq question
    # end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    # context является элиусом describe
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
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
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
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }

        # reload обновит наш объект теми данными которые есть в БД
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'whith invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        # чтобы не получился ложноположительный тест, возьмемм вручную данные из фабрики MyString и MyText и укажем в явном виде
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    it 'delete the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
