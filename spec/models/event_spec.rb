require 'rails_helper'

describe "Event" do
  before do
    @owner = FactoryGirl.create(:user)
    @event = FactoryGirl.create(:event, owner: @owner )
  end
  subject{ @event }

  it "should be valid" do
    expect(subject).to be_valid
  end

  it "should respond to" do
    expect(subject).to respond_to(
      :pretty_start_time,
      :pretty_end_time,
      :owner,
      :ended?,
      :days_short,
      :days_long,
      :days_as_string
    )
  end

  describe "should be invalid when" do
    it "no days are selected" do
      subject.days_of_the_week = 0
      expect(subject).not_to be_valid
    end

    it "start time equal to or later than end time" do
      subject.start_time = Time.parse("1:00pm")
      subject.end_time = Time.parse("9:00am")
      expect(subject).not_to be_valid
    end

    it "name is nil" do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it "start time is nil" do
      subject.start_time = nil
      expect(subject).not_to be_valid
    end

    it "end time is nil" do
      subject.end_time = nil
      expect(subject).not_to be_valid
    end

    it "owner is nil" do
      subject.owner = nil
      expect(subject).not_to be_valid
    end

    describe "type is weekly and" do
      before{ @event.update_attribute(:event_type, :weekly) }

      it "days of the week is nil" do
        subject.days_of_the_week = nil
        expect(subject).not_to be_valid
      end
    end

    describe "type is one time" do
      before{ @event.update_attribute(:event_type, :one_time) }

      it "date is nil" do
        subject.event_date = nil
        expect(subject).not_to be_valid
      end
    end
  end

  describe "relation" do
    before do
      @dt = "Jan 3 2000 4:00pm pst".to_datetime #monday
      allow(Time).to receive(:now).and_return(@dt.to_time)
      allow(Event).to receive(:current_day).and_return("monday")
      allow(Date).to receive(:today).and_return(@dt.to_date)

      @past_event = FactoryGirl.create(:event,
        owner: @owner, event_type: :one_time, event_date: @dt.to_date - 1.days)

      @ongoing_event = FactoryGirl.create(:event,
        owner: @owner,
        event_type: :one_time,
        event_date: @dt.to_date,
        start_time: @dt.to_time - 1.hours,
        end_time: @dt.to_time + 1.hours )

      @upcoming_event = FactoryGirl.create(:event,
        owner: @owner, event_type: :one_time, event_date: @dt.to_date + 1.days)

      @upcoming_event_today = FactoryGirl.create(:event,
        owner: @owner,
        event_type: :one_time,
        event_date: @dt.to_date,
        start_time: @dt.to_time + 2.hours,
        end_time: @dt.to_time + 3.hours )
    end

    describe "past" do
      it "includes only past events" do
        expect(Event.past).not_to include(@event)
        expect(Event.past).to include(@past_event)
        expect(Event.past).not_to include(@ongoing_event)
        expect(Event.past).not_to include(@upcoming_event)
        expect(Event.past).not_to include(@upcoming_event_today)
      end
    end

    describe "upcoming" do
      it "includes only upcoming events" do
        expect(Event.upcoming).to include(@event)
        expect(Event.upcoming).not_to include(@past_event)
        expect(Event.upcoming).not_to include(@ongoing_event)
        expect(Event.upcoming).to include(@upcoming_event)
        expect(Event.upcoming).not_to include(@upcoming_event_today)
      end
    end
  end

  describe "#every_tuesday" do
    before do
      @event.update_attribute(:days_of_the_week, 2)
      @event2 = FactoryGirl.create(:event, owner: @owner, days_of_the_week: 4)
    end
    it "should return event on the day" do
      expect(Event.every_tuesday).to include(@event)
    end
    it "should not return events not on the day" do
      expect(Event.every_tuesday).not_to include(@event2)
    end
  end
end
