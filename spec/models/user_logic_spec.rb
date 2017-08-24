require 'rails_helper'

RSpec.describe UserLogic, type: :model do
  describe ".create" do
    describe "with valid attributes" do
      describe "by class" do
        it_behaves_like "UserLogic.create" do
          let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }
        end
      end

      describe "by kind" do
        describe "as symbol" do
          it_behaves_like "UserLogic.create" do
            let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)).merge(kind: :advertiser)}
          end
        end

        describe "as string" do
          it_behaves_like "UserLogic.create" do
            let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)).merge(kind: "advertiser")}
          end
        end
      end
    end

    describe "with invalid attributes" do
      let(:advertiser_params) { attributes_for(:user).merge(attributes_for(:advertiser)) }

      it "call from BaseLogic" do
        expect { BaseLogic.create }.to raise_error BaseLogic::InterfaceNotImplemented
      end

      it "without kind from UserLogic" do
        expect { UserLogic.create(params: advertiser_params) }.to raise_error BaseLogic::InterfaceNotImplemented
      end
    end
  end
end