require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #show" do
    let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }
    let!(:advertiser) { AdvertiserLogic.create(advertiser_params) }

    before { get :show, params: { id: advertiser.id} }

    it 'assigns advertiser to @user' do
      expect(assigns(:user).id).to eq advertiser.id
    end

    it '@user type of ' do
      expect(assigns(:user)).to be_a AdvertiserLogic
    end

    %w(name phone email organization position).each do |attr|
      it "user object contains #{attr}" do
        subject
        expect(response.body).to be_json_eql(advertiser_params[attr.to_sym].to_json).at_path("#{attr}")
      end
    end

  end

  # describe "POST #create" do
  #   let!(:user_params) { attributes_for(:user)
  #                            .merge(attributes_for(:advertiser))
  #                            .merge(kind: :advertiser) }
  #
  #   subject { post :create, params: user_params, format: :json }
  #
  #   it 'returns 200 status' do
  #     subject
  #     expect(response).to be_success
  #   end
  #
  #   it 'saves the new user to database' do
  #     expect { subject }.to change(User, :count).by(1)
  #   end
  #
  #   it 'saves the new advertiser to database' do
  #     expect { subject }.to change(Advertiser, :count).by(1)
  #   end
  #
  #   # %w(title body).each do |attr|
  #   #   it "question object contains #{attr}" do
  #   #     subject
  #   #     expect(response.body).to be_json_eql(question_params[attr.to_sym].to_json).at_path("#{attr}")
  #   #   end
  #   # end
  # end

end