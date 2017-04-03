require 'rails_helper'
require './app/services/delete_records_service.rb'
        

RSpec.describe "delete services" do
	context "festival" do
		describe "show records to be deleted" do
			it "finds and shows a record to delete" do
				festival = create(:festival, year: "2015")			
				cShow = FestivalShow.new(year: '2015')
				expect{cShow.run}.to output(/For 2015 the following records found/).to_stdout
				expect{cShow.run}.to output(/#{festival.title} #{festival.year} #{festival.startdate}/).to_stdout
			end
			it "does not find record with different year" do
				festival = create(:festival, year: "2015")
				festival2 = create(:festival, year: "2014")
				festival3 = create(:festival, year: "2016")
				cShow = FestivalShow.new(year: '2015')
				expect{cShow.run}.to output(/For 2015 the following records found/).to_stdout
				expect{cShow.run}.to_not output(/#{festival2.title} #{festival2.year} #{festival2.startdate}/).to_stdout
				expect{cShow.run}.to_not output(/#{festival3.title} #{festival3.year} #{festival3.startdate}/).to_stdout
			end
			it "finds no records to delete" do
				festival = create(:festival, year: "2014")
				cShow = FestivalShow.new(year: '2015')
				expect{cShow.run}.to output(/For 2015 the following records found/).to_stdout
				expect{cShow.run}.to_not output(/#{festival.title} #{festival.year} #{festival.startdate}/).to_stdout
			end
			it "finds no records to delete when invalid year" do
				festival = create(:festival, year: "2014")
				cShow = FestivalShow.new(year: 'invalid')
				expect{cShow.run}.to output(/For invalid the following records found/).to_stdout
				expect{cShow.run}.to_not output(/#{festival.title} #{festival.year} #{festival.startdate}/).to_stdout
			end

		end
		describe "delete selected records" do
			it "finds and deletes record" do
				festival = create(:festival, year: "2015")
				cDelete = FestivalDelete.new(year: '2015')
				expect{cDelete.run}.to change(Festival, :count).by(-1)
			end
			it "shows the year for records to be deleted" do
				festival = create(:festival, year: "2015")
				cDelete = FestivalDelete.new(year: '2015')
				expect{cDelete.run}.to output(/Deleting records for 2015:/).to_stdout
			end
		end
	end
	context "favourites" do
		describe "show records to be deleted" do
			it "counts favourite records to delete" do
				favourite = create(:user_for_favourite)
				cShow = FavouritesShow.new()
				expect{cShow.run}.to output(/There is 1 favourite artist record to delete and there are 0 favourite performance records to delete/).to_stdout
			end
			it "counts favourite perfromance records to delete" do
				favourite = create(:user_for_favourites_with_performances)
				cShow = FavouritesShow.new()
				expect{cShow.run}.to output(/There is 1 favourite artist record to delete and there are 3 favourite performance records to delete/).to_stdout
			end
			it "finds no records to delete" do
				cShow = FavouritesShow.new()
				expect{cShow.run}.to output(/There are 0 favourite artist records to delete and there are 0 favourite performance records to delete/).to_stdout
			end
		end
		describe "delete selected records" do
			it "finds and deletes record" do
				favourite = create(:user_for_favourite)
				cDelete = FavouritesDelete.new()
				expect{cDelete.run}.to change(Favourite, :count).by(-1)
			end
			it "finds and deletes all favourite and favourite performance records" do
				favourite = create(:user_for_favourites_with_performances)
				cDelete = FavouritesDelete.new()
				expect{cDelete.run}.to change(Favouriteperformance, :count).by(-3)
			end
		end
	end
end
