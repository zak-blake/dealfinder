require 'rails_helper'

describe "Event Pages" do
  before do
    @owner = FactoryGirl.create(:user)
    @weekly_event = FactoryGirl.create(:event, owner: @owner, days_of_the_week: 1)
    @one_time_event = FactoryGirl.create(:event, owner: @owner, event_type: :one_time, event_date: Date.today)
  end

  describe "as public user" do
    describe "new" do
      it "should redirect to login page" do
        expect(get new_event_path).to redirect_to new_user_session_path
      end
    end

    describe "create" do
      it "should redirect to login page" do
        expect(post events_path).to redirect_to new_user_session_path
      end
    end

    describe "show" do
      it "should have weekly event content" do
        #event card layout
        visit event_path(@weekly_event)
        expect(page).to have_content(@weekly_event.name)
        expect(page).to have_content(@weekly_event.owner.name)
        expect(page).to have_content(@weekly_event.pretty_start_time)
        expect(page).to have_content(@weekly_event.pretty_end_time)
        expect(page).not_to have_content("edit")
        expect(page).not_to have_content("delete")
      end

      it "should have one time event content" do
        #event card layout
        visit event_path(@one_time_event)
        expect(page).to have_content(@one_time_event.name)
        expect(page).to have_content(@one_time_event.owner.name)
        expect(page).to have_content(@one_time_event.pretty_start_time)
        expect(page).to have_content(@one_time_event.pretty_end_time)
        expect(page).not_to have_content("edit")
        expect(page).not_to have_content("delete")
      end
    end

    describe "edit" do
      it "should redirect to login page" do
        expect(get edit_event_path(@weekly_event)).to redirect_to new_user_session_path
      end
    end

    describe "update" do
      it "should redirect to login page" do
        expect(patch event_path(@weekly_event)).to redirect_to new_user_session_path
        expect(put event_path).to redirect_to new_user_session_path
      end
    end

    describe "index" do
      it "should have have index page content" do
        visit events_path
        expect(page).to have_content("what's going on")
        expect(page).to have_content("Login")
        expect(page).to have_content("Signup")
      end

      describe "when there is an event" do
        before do
          time = Time.parse("Jan 3 2000 4:00pm utc)") #monday
          allow(Time).to receive(:now).and_return(time)
          allow(Event).to receive(:current_day).and_return("monday")
        end
        describe "today" do
          before do
            @weekly_event.days_of_the_week = 1
            @weekly_event.save!
            @weekly_event.reload
          end

          describe "that has not passed" do
            before do
              @weekly_event.start_time = Time.parse("2:00pm utc")
              @weekly_event.end_time = Time.parse("6:00pm utc")
              @weekly_event.save!
              @weekly_event.reload
              visit events_path
            end
            it "should display the event" do
              expect(page).to have_content(@weekly_event.name)
            end
          end

          describe "that has already passed" do
            before do
              @weekly_event.start_time = Time.parse("2:00pm utc")
              @weekly_event.end_time = Time.parse("3:00pm utc")
              @weekly_event.save!
              @weekly_event.reload
            end

            it "should not display the event" do
              visit events_path
              expect(page).not_to have_content(@weekly_event.name)
            end

            describe "on a different day" do
              before{ @weekly_event.update_attribute(:days_of_the_week, 3)}
              it "should display the event" do
                visit events_path(day: "tuesday")
                expect(page).to have_content(@weekly_event.name)
              end
            end
          end
        end

        describe "not today" do
          before do
            @weekly_event.days_of_the_week = 4
            @weekly_event.save!
            @weekly_event.reload
          end

          it "should not show the event" do
            visit events_path
            expect(page).not_to have_content(@weekly_event.name)
          end
        end
      end

      describe "when there is a one-time event" do
        before do
          @one_time_event.save!
          @one_time_event.reload
        end

        describe "today" do
          before do
            allow(Time).to receive(:now).and_return(Time.parse("12:00pm"))
            allow(Date).to receive(:today).and_return(Date.today)
          end

          it "should not display the event" do
            visit events_path
            expect(page).to have_content(@one_time_event.name)
          end
        end

        describe "not today" do
          before { allow(Date).to receive(:today).and_return(Date.new(2001,2,3) ) }

          it "should not display the event" do
            visit events_path
            expect(page).not_to have_content(@one_time_event.name)
          end
        end

        describe "today that has passed" do
          before do
            allow(Time).to receive(:now).and_return(Time.parse("11:00pm"))
            allow(Date).to receive(:today).and_return(Date.today)
          end

          it "should not display the event" do
            visit events_path
            expect(page).not_to have_content(@one_time_event.name)
          end
        end
      end
    end

    describe "destroy" do
      it "should redirect to login page" do
        expect(delete event_path(@weekly_event)).to redirect_to new_user_session_path
      end
    end
  end

  describe "as owner" do
    before do
      login_as(@owner, scope: :user)
    end

    describe "show" do
      it "should have owner options" do
        visit event_path(@weekly_event)
        expect(page).to have_content("edit")
        expect(page).to have_content("delete")
      end
    end

    describe "new" do
      before do
        visit new_event_path
      end
      it "should show new event form" do
        expect(page).to have_content("New Event")
      end

      describe "fills out form" do
        before do
          fill_in "Name", with: "cool event"
          fill_in "Description", with: "cool description"
          page.check("weekday1_select")
          select "09", from: "event_start_time_4i"
          select "30", from: "event_start_time_5i"
          select "10", from: "event_end_time_4i"
          select "45", from: "event_end_time_5i"
        end
        specify{ expect{ click_button "Create Event" }.to change(Event, :count).by(1) }

        describe "saves event" do
          before{ click_button "Create Event" }
          subject{ Event.where(name: "cool event").last }
          specify do
            expect(subject.name).to eq("cool event")
            expect(subject.pretty_start_time).to eq("9:30 am")
            expect(subject.pretty_end_time).to eq("10:45 am")
            expect(subject.days_of_the_week).to eq(1)
          end
        end
      end
    end

    describe "who owns event" do
      describe "edit" do
        before do
          visit edit_event_path(@weekly_event)
        end
        it "should show edit event form" do
          expect(page).to have_content("Edit")
        end

        describe "fills out form" do
          before do
            fill_in "Name", with: "cool event"
            fill_in "Description", with: "cool description"
            page.uncheck("weekday1_select")
            page.check("weekday2_select")
            select "09", from: "event_start_time_4i"
            select "30", from: "event_start_time_5i"
            select "10", from: "event_end_time_4i"
            select "45", from: "event_end_time_5i"
          end
          specify{ expect{ click_button "Update" }.not_to change(Event, :count) }

          describe "saves event" do
            before{ click_button "Update" }
            subject{ Event.where(name: "cool event").last }
            specify do
              expect(subject.name).to eq("cool event")
              expect(subject.pretty_start_time).to eq("9:30 am")
              expect(subject.pretty_end_time).to eq("10:45 am")
              expect(subject.days_of_the_week).to eq(2)
            end
          end
        end
      end
    end

    describe "who does not own event" do
      before do
        @owner2 = FactoryGirl.create(:user)
        @weekly_event2 = FactoryGirl.create(:event, owner: @owner2)
      end
      describe "edit" do
        it "should redirect to root page" do
          expect(get edit_event_path(@weekly_event2)).to redirect_to root_path
        end
      end
    end
  end
end
