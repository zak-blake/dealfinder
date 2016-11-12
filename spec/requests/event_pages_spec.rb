require 'rails_helper'

describe "Event Pages" do
  describe "as public user" do
    describe "index" do
      before do
        visit '/events'
      end
      specify { expect(page).to have_content("what's going on") }
      specify { expect(page).to have_content("Login") }
      specify { expect(page).to have_content("Signup") }
    end
  end
end
