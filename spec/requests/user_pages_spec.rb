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

  describe "index" do
    describe "when there are 2 approved owners" do
      let(:owner_a) { FactoryGirl.create(:user, approved_status: :status_approved) }
      let(:owner_b) { FactoryGirl.create(:user, approved_status: :status_approved) }

      before do
        owner_a.save!
        owner_b.save!
        visit users_path
      end

      it "should show the names of all owners" do
        expect(page).to have_content(owner_a.reload.name)
        expect(page).to have_content(owner_b.reload.name)
      end
    end
  end

  describe "update" do
    let(:update_params) {
      { user: { approved_status: :status_approved } }
    }

    describe "as non admin" do
      it "should redirect to root" do
        expect(
          patch update_user_path(owner), params: update_params
        ).to redirect_to root_path
      end
    end

    describe "as admin" do
      before do
        sign_in FactoryGirl.create(:admin)
      end

      it "should not redirect to root" do
        expect(
          patch update_user_path(owner), params: update_params
        ).not_to redirect_to root_path
      end
    end
  end
end
