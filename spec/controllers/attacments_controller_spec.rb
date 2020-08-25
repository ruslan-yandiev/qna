require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:author) { create(:author) }
  let!(:question) { create(:question, :with_file, user: author) }
  let!(:answer) { create(:answer, :with_file, question: question, user: author) }

  describe 'DELETE #destroy' do
    before { login(author) }

    context 'The user is trying to delete a file on his resource' do
      it 'deletes file on his question' do
        expect { delete :destroy, params: { id: question.files[0].id }, format: :js }.to change(question.files, :count).by(-1)
        expect(response).to render_template :destroy
      end

      it 'deletes file on his answer' do
        expect { delete :destroy, params: { id: answer.files[0].id }, format: :js }.to change(answer.files, :count).by(-1)
        expect(response).to render_template :destroy
      end
    end

    context "The user is trying to delete a file on someone else's resource" do
      before { sign_in(create(:author)) }

      it 'unsuccessful deletion of the file from the question' do
        expect { delete :destroy, params: { id: question.files[0].id }, format: :js }.to_not change(question.files, :count)
        expect(response).to have_http_status 403
      end

      it 'unsuccessful deletion of the file from the answer' do
        expect { delete :destroy, params: { id: answer.files[0].id }, format: :js }.to_not change(answer.files, :count)
        expect(response).to have_http_status 403
      end
    end
  end
end