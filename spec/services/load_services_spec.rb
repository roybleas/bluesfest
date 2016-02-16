require 'rails_helper'
require './app/services/load_service.rb'
require 'date'        

RSpec.describe "load services" do
	context "Counter" do
		before(:each) do
			@counter = RecordCounter.new('things')
		end
		it "creates counter class" do
			expect(@counter).to_not be_nil
		end
		it "requires initialize with record type being counted" do
			expect {counter = RecordCounter.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "has totals that are initially zero" do
			expect(@counter.total_added).to eq 0 
			expect(@counter.total_updated).to eq 0 
		end
		it "increments add total on calling add" do
			@counter.add_record
			@counter.add_record
			expect(@counter.total_added).to eq 2
			expect(@counter.total_updated).to eq 0 
		end
		it "increments update total on calling update" do
			@counter.update_record
			@counter.update_record
			@counter.update_record
			expect(@counter.total_updated).to eq 3
			expect(@counter.total_added).to eq 0	 
		end
		it "increments corrects totals when add and update " do
			@counter.update_record
			@counter.add_record
			@counter.update_record
			expect(@counter.total_updated).to eq 2
			expect(@counter.total_added).to eq 1	 
		end
		it "outputs totals as a message" do
			addcount = 3
			updatecount = 5
			(1..addcount).each {@counter.add_record}
			(1..updatecount).each {@counter.update_record}
			expect(@counter.print_totals).to eq "Added: #{addcount} and updated: #{updatecount} things"
		end
		it "pluralizes hte type of records being counted" do
			counter = RecordCounter.new('thing')
			expect(@counter.print_totals).to match /things/
		end
		
	end
end
