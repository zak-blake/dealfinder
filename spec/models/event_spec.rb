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

  it "should respond" do
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
end
