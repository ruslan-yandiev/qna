require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:rewards) { create_list(:reward, 3, user: user) }

  describe 'GET #index' do
    before do
      sign_in(user)
      get :index
    end

    it 'adds awards to the collection' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end