require 'rails_helper'
require './app/services/load_artist_pages_service.rb'
        

RSpec.describe "load services" do
	context "Artist pages" do
		context "create valid loader" do
			before(:example) do
				@festival = build(:festival)
			end
			it "class is valid" do
				expect(LoadArtistPages.new("textfile",@festival)).to_not be_nil
			end
			it "requires initialize with file and festival" do
				expect {load = LoadArtistPages.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
			end

			it "requires a csv file  " do
				loader = LoadArtistPages.new("invalid",@festival)
				expect {loader.load }.to raise_error(/No such file or directory/)
			end
		end
		context"with valid input file" do
			before(:example) do
				@festival = create(:festival)
				csv_filename = './spec/files/artistpages.csv'
				@cLoad = LoadArtistPages.new(csv_filename,@festival)
			end
			it "adds pages" do
				expect{@cLoad.load}.to change(Artistpage, :count).by(8)
			end
			it "puts out a summary message" do
				expect{@cLoad.load}.to output(/Added: 8 Artist pages/).to_stdout
			end
			it "has correct number of records belonging to the festival" do
				@cLoad.load
				expect( Artistpage.where('festival_id = ?',@festival.id).count).to eq 8
			end
			it "removes previous rows for festival before loading new " do
					@cLoad.load
					@cLoad.load
					expect( Artistpage.where('festival_id = ?',@festival.id).count).to eq 8
			end
			it "only previous rows for passed in festival " do

					@cLoad.load
					
					festival = create(:festival)
					csv_filename = './spec/files/artistpages.csv'
					otherLoad = LoadArtistPages.new(csv_filename,festival)
					otherLoad.load
					expect( Artistpage.where('festival_id = ?',festival.id).count).to eq 8
					
					@cLoad.load
					expect( Artistpage.where('festival_id = ?',@festival.id).count).to eq 8
					
					expect( Artistpage.where('festival_id = ?',festival.id).count).to eq 8
			end


		end
	end
end