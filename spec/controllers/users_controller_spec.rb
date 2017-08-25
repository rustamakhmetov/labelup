require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET /show" do
    let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }
    let!(:advertiser) { AdvertiserLogic.create(params: advertiser_params) }

    before { get :show, params: { id: advertiser.id} }

    it 'assigns advertiser to @user' do
      expect(assigns(:user).id).to eq advertiser.id
    end

    it '@user type of AdvertiserLogic' do
      expect(assigns(:user)).to be_a AdvertiserLogic
    end

    %w(name phone email organization position).each do |attr|
      it "user object contains #{attr}" do
        subject
        expect(response.body).to be_json_eql(advertiser_params[attr.to_sym].to_json).at_path("#{attr}")
      end
    end

  end

  describe "POST /create" do

    describe "with valid attributes" do
      let!(:user_params) { attributes_for(:user)
                               .merge(attributes_for(:advertiser))
                               .merge(kind: :advertiser) }

      subject { post :create, params: {user: user_params}, format: :json }

      it 'returns 200 status' do
        subject
        expect(response).to be_success
      end

      it 'saves the new user to database' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'saves the new advertiser to database' do
        expect { subject }.to change(Advertiser, :count).by(1)
      end

      %w{name email phone organization position}.each do |attr|
        it "user object contains #{attr}" do
          subject
          expect(response.body).to be_json_eql(user_params[attr.to_sym].to_json).at_path("#{attr}")
        end
      end
    end

    describe "with invalid attributes" do
      subject { post :create, params: {user: user_params}, format: :json }

      describe "without 'kind' parameter" do
        let(:user_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an error message' do
          subject
          expect(response.body).to be_json_eql(["Invalid parameters"].to_json).at_path("errors")
        end
      end

      describe "unknown 'kind' parameter" do
        let(:user_params) { attributes_for(:user).merge(attributes_for(:advertiser)).merge(kind: :unknown) }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an error message' do
          subject
          expect(response.body).to be_json_eql(["Unknown user kind"].to_json).at_path("errors")
        end
      end

      describe "with empty validate attributes" do
        let(:user_params) { attributes_for(:user).merge(attributes_for(:advertiser))
                                .merge(kind: :advertiser).except(:email, :position) }

        it 'returns 422 status' do
          subject
          expect(response).to have_http_status(422)
        end

        it 'returns an error message' do
          subject
          expect(response.body).to be_json_eql(["Email can't be blank",
                                                "Position can't be blank"].to_json).at_path("errors")
        end
      end
    end
  end

  describe "PATCH /update" do
    let!(:user_params) { attributes_for(:user)
                             .merge(attributes_for(:advertiser)) }
    let!(:advertiser) { AdvertiserLogic.create(params: user_params) }


    context 'with valid attributes' do
      subject { patch :update, params:  { user: {name: "New name", position: "New position" },
                                          id: advertiser.id, format: :json } }

      it 'assigns the requested advertiser to @user' do
        subject
        expect(assigns(:user).id).to eq advertiser.id
      end

      it 'change advertiser attributes' do
        subject
        advertiser.reload
        expect(advertiser.name).to eq 'New name'
        expect(advertiser.position).to eq 'New position'
      end
    end

    context "with invalid attributes" do
      context "advertiser not exists" do
        it_behaves_like "UserController returns errors" do
          subject { patch :update, params:  { user: {name: "New name", position: "New position" },
                                              id: 100, format: :json } }
          let!(:errors) { ["User not exists"] }
        end
      end

      context "required fields are not filled" do
        it_behaves_like "UserController returns errors" do
          subject { patch :update, params:  { user: {name: "", position: "" },
                                              id: advertiser.id, format: :json } }
          let!(:errors) { ["Name can't be blank", "Position can't be blank"]}
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user_params) { attributes_for(:user)
                             .merge(attributes_for(:advertiser)) }
    let!(:advertiser) { AdvertiserLogic.create(params: user_params) }

    context "with valid attributes" do
      subject { delete :destroy, params:  { id: advertiser.id, format: :json } }

      it "deletes advertiser" do
        expect { subject }.to change(Advertiser, :count).by(-1)
      end

      it "deletes user" do
        expect { subject }.to change(User, :count).by(-1)
      end
    end

    context "with invalid attributes" do
      context "advertiser not exists" do
        it_behaves_like "UserController returns errors" do
          subject { delete :destroy, params:  { id: 100, format: :json } }
          let!(:errors) { ["User not exists"] }
        end
      end
    end
  end

end