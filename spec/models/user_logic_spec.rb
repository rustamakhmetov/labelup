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

  describe ".to_kind" do
    describe "with valid attributes" do
      it "kind :advertiser" do
        expect(AdvertiserLogic.to_kind).to eq :advertiser
      end

      it "klass as parameter" do
        expect(UserLogic.to_kind(AdvertiserLogic)).to eq :advertiser
      end
    end

    describe "with invalid attributes" do
      it "invalid class name" do
        class Unknow < UserLogic; end
        expect(Unknow.to_kind).to eq nil
      end
    end
  end

  describe "#to_kind" do
    describe "with valid attributes" do
      it "AdvertiserLogic" do
        expect(AdvertiserLogic.new.to_kind).to eq :advertiser
      end

      it "AdministratorLogic" do
        class AdministratorLogic < UserLogic; end
        expect(AdministratorLogic.new.to_kind).to eq :administrator
      end
    end

    describe "with invalid attributes" do
      it "invalid class name" do
        class Unknow < UserLogic; end
        expect(Unknow.new.to_kind).to eq nil
      end
    end
  end

  describe ".allow_kinds" do
    it "returns array of kinds" do
      class AdministratorLogic < UserLogic; end
      class Invalid < UserLogic; end
      # with active 'focus: true [fit]' the test is failed
      expect(UserLogic.allow_kinds).to match_array([:administrator, :advertiser])
    end
  end


end