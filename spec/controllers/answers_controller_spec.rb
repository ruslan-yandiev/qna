require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to answer show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view ' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

    describe 'PATCH #update' do
    context 'whith valid attributes' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: question }

        # reload обновит наш объект теми данными которые есть в БД
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to answer
      end
    end

    context 'whith invalid attributes' do
      # выполним перед запуском каждого теста в этом контексте
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not change answer' do
        answer.reload

        # чтобы не получился ложноположительный тест, возьмемм вручную данные MyText из фабрики и укажем в явном виде
        expect(answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end