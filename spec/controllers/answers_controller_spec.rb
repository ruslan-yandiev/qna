require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:author) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: author) }

  before { login(author) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question },format: :js }.to change(question.answers, :count).by(1)
      end

      it 'answer belongs to the author' do
        post :create, params: { answer: attributes_for(:answer), question_id: question },format: :js
        expect(question.answers.last.user_id).to eq(author.id)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question },format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question },format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'whith valid attributes' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }, format: :js

        # reload обновит наш объект теми данными которые есть в БД
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'whith invalid attributes' do
      # выполним перед запуском каждого теста в этом контексте
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }

      it 'does not change answer' do
        answer.reload

        # чтобы не получился ложноположительный тест, возьмемм вручную данные My_Answer_Text из фабрики и укажем в явном виде
        # expect(answer.body).to eq 'My_Answer_Text'

        expect { answer.body }.to_not change(answer, :body)
      end

      it 'render update view' do
        expect(response).to render_template :update
      end
    end

    context 'Only the author can update his answer' do
      before { sign_in(create(:user)) }

      it 'answer body has not changed' do
        patch :update, params: { id: answer, answer: { body: 'new answer' }, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new answer'
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Author of the answer' do
      let!(:answer) { create(:answer, question: question, user: author) }
      
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not the author of the answer' do
      let!(:answer) { create(:answer, question: question) }
      
      it 'Answer is not deleted' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end