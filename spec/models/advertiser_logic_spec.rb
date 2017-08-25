require 'rails_helper'

RSpec.describe AdvertiserLogic, type: :model do
  describe "#save" do
    describe "with valid attributes" do
      let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }
      let(:advertiser1) { AdvertiserLogic.new(advertiser_params) }
      let(:advertiser2) { AdvertiserLogic.new(advertiser_params) }
      subject { advertiser1.save }

      it "save user to database" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "save advertiser to database" do
        expect { subject }.to change(Advertiser, :count).by(1)
      end

      it "denied duplication save" do
        expect do
          advertiser1.save
          advertiser2.save
        end.to raise_error ActiveRecord::RecordNotUnique
      end
    end

    it_behaves_like "Advertiser with invalid attributes" do
      let(:advertiser_invalid_params) { attributes_for(:user) }
      let(:object ) { AdvertiserLogic.new(advertiser_invalid_params) }
      let!(:errors) { ["Organization can't be blank", "Position can't be blank"] }
    end

    it_behaves_like "Advertiser with invalid attributes" do
      let(:advertiser_invalid_params) { attributes_for(:advertiser) }
      let(:object ) { AdvertiserLogic.new(advertiser_invalid_params) }
      let!(:errors) { ["Email can't be blank", "Name can't be blank", "Password can't be blank"] }
    end
  end

  describe "#persisted?" do
    describe "with valid attributes" do
      let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }
      let(:advertiser) { AdvertiserLogic.new(advertiser_params) }

      it "return true" do
        advertiser.save
        expect(advertiser.persisted?).to eq true
      end
    end

    describe "with invalid attributes" do
      let(:advertiser_invalid_params) { nil }
      let(:advertiser) { AdvertiserLogic.new(advertiser_invalid_params) }

      it "return false" do
        advertiser.save
        expect(advertiser.persisted?).to eq false
      end
    end
  end
end