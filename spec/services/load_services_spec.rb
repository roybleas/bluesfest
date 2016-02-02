require 'rails_helper'
require './app/services/load_service.rb'
        

RSpec.describe "load services" do
	context "festival" do
		it "does not have a valid file name " do
			cLoad = LoadFestival.new('invalid')
			expect{cLoad.load}.to raise_error(/No such file or directory/)
		end
		
		it "creates festival record with corect details from csv file" do
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			cLoad.load
			festival = Festival.take
			expect(festival.year).to eq("2016")
			expect(festival.startdate).to eq(Date.parse("2016-3-24"))
			expect(festival.days).to eq(5)
			expect(festival.scheduledate).to eq(Date.parse("2016-1-28"))
			expect(festival.title).to eq("Bluesfest")
			expect(festival.major).to eq(0)
			expect(festival.minor).to eq(1)
			expect(festival.active).to be_truthy
		end
		it "saves the new festival to the database" do
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			expect{cLoad.load}.to change(Festival, :count).by(1)
		end
		it "updates the festival in the database" do
			festival = create(:festival, startdate: "2016-3-24")
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			expect{cLoad.load}.to change(Festival, :count).by(0)
		end
 			
		it "outputs a message for each festival record created" do
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			expect{ cLoad.load}.to output(/Loaded festival Bluesfest for 2016/).to_stdout
		end
	end
end
