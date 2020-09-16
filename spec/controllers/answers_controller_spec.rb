require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:author) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: author) }
  let(:answer2) { create(:answer, question: question, user: user) }

  before { login(author) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question },format: :json }.to change(question.answers, :count).by(1)
      end

      it 'answer belongs to the author' do
        post :create, params: { answer: attributes_for(:answer), question_id: question },format: :json
        expect(question.answers.last.user_id).to eq(author.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :json }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question },format: :json
        expect(response).to have_http_status 422
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

  describe 'PATCH #best' do
    context 'user set a best answer to own question' do
      it 'chooses the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context 'user tries to set a best answer to not own question' do
      let(:other_answer) { create(:answer, :best, question: question) }

      it 'does not choose the answer as the best' do
        sign_in(create(:user))

        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).not_to be_best
      end
    end
  end

  describe 'POST #voteup' do
    context 'User tries to create a new up vote to a answer' do
      it 'creates a new voice without being the author of the answer' do
        expect { post :voteup, params: { id: answer2 }, format: :json }.to change(answer2.votes, :count).by(1)
      end

      it 'does not create a new voice by being the author of the answer' do
        expect { post :voteup, params: { id: answer }, format: :json }.to_not change(answer.votes, :count)
      end
    end
  end

  describe 'POST #votedown' do
    context 'User tries to create a new up vote to a answer' do
      it 'creates a new voice without being the author of the answer' do
        expect { post :votedown, params: { id: answer2 }, format: :json }.to change(answer2.votes, :count).by(1)
      end

      it 'does not create a new voice by being the author of the answer' do
        expect { post :votedown, params: { id: answer }, format: :json }.to_not change(answer.votes, :count)
      end
    end
  end
end