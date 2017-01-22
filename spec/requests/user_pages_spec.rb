require 'rails_helper'

describe "User Pages" do
  let(:owner) { FactoryGirl.create(:user) }


  describe "show" do
    describe "as public user" do
      describe "that is not approved" do
        before do
          owner.approved_status = :status_unapproved
          owner.save!
        end

        it "should redirect to root" do
          expect(get user_path(owner)).to redirect_to root_path
        end
      end

      describe "that is approved" do
        before do
          owner.approved_status = :status_approved
          owner.save!
        end

        it "should not redirect to root" do
          expect(get user_path(owner)).not_to redirect_to root_path
        end
      end
    end

    describe "as admin user" do
      before do
        sign_in FactoryGirl.create(:admin)
      end

      describe "that is not approved" do
        before do
          owner.approved_status = :status_approved
          owner.save!
        end

        it "should redirect to root" do
          expect(get user_path(owner)).not_to redirect_to root_path
        end
      end

      describe "that is approved" do
        before do
          owner.approved_status = :status_approved
          owner.save!
        end

        it "should not redirect to root" do
          expect(get user_path(owner)).not_to redirect_to root_path
        end
      end
    end
  end
end
