require 'rails_helper'
require './app/services/load_service.rb'
require 'date'        

RSpec.describe "load services" do
	context "extract artist code" do
		it "returns lower case code unchanged" do
			expect(ArtistCode.extract("abc")).to eq "abc"
		end
		it "converts upper to lower case" do
			expect(ArtistCode.extract("ABC")).to eq "abc"
		end		
		it "removes spaces " do
			expect(ArtistCode.extract(" a Bc d ")).to eq "abcd"
		end
		it "removes apostrophes " do
			expect(ArtistCode.extract(" a' b'cd 'e ")).to eq "abcde"
		end
		it "removes ampersands " do
			expect(ArtistCode.extract("& a& b&cd &e & &")).to eq "abcde"
		end
		it "removes double quotation marks " do
			expect(ArtistCode.extract('"& a" bcd "e "')).to eq "abcde"
		end
		it "removes commas " do
			expect(ArtistCode.extract(', a,, bcd, ,e ,')).to eq "abcde"
		end
		it "removes fullstops " do
			expect(ArtistCode.extract('. a. bc.de .')).to eq "abcde"
		end
		it "real world examples" do
			expect(ArtistCode.extract("D'Angelo")).to eq "dangelo"
			expect(ArtistCode.extract('Eugene "Hideaway" Bridges')).to eq "eugenehideawaybridges"
			expect(ArtistCode.extract("Noel Gallagher's High Flying Birds")).to eq "noelgallaghershighflyingbirds"
		end
	end
	context "artists" do
		context "with festival data file" do
			before(:each) do
				filename = './spec/files/festival.yml'
				@currentFestival = CurrentFestival.new(filename)
				@currentFestival.load
				@csv_filename = './spec/files/artists.csv'
			end
			it "does not have a festival record " do
				cLoad = LoadArtists.new('invalid',@currentFestival)
				expect{cLoad.load}.to raise_error(LoadArtistError,/Festival database record not found/)
			end
			it "does not match the requested festival record " do
				festival = create(:festival, title: "alternative title", startdate: @currentFestival.startdate)
				cLoad = LoadArtists.new(@csv_filename,@currentFestival)
				expect{cLoad.load}.to raise_error(LoadArtistError,/Festival database record not found/)
			end
			
			context "with valid festival record" do
				before(:each) do
					festival = create(:festival, title: @currentFestival.title, startdate: @currentFestival.startdate)
					@festival_id = festival.id
					@cLoad = LoadArtists.new(@csv_filename,@currentFestival)
				end
				it "raises error when artists file not found " do
					cLoad = LoadArtists.new("invalid",@currentFestival) 
					expect{cLoad.load}.to raise_error(/No such file or directory/)
				end
				it "finds current festival record" do
					expect{@cLoad.load}.to_not raise_error
				end
				it "is missing extract date" do
					filename = './spec/files/invalid01_artists.csv'
					cLoad = LoadArtists.new(filename,@currentFestival)
					expect{cLoad.load}.to raise_error(LoadArtistError,/Missing artist file extract date/)
				end
				it "has invalid extract date" do
					filename = './spec/files/invalid02_artists.csv'
					cLoad = LoadArtists.new(filename,@currentFestival)
					expect{cLoad.load}.to raise_error(LoadArtistError,/Invalid extract date in artist file/)
				end
				it "adds artists" do
					expect{@cLoad.load}.to change(Artist, :count).by(2)
				end
				it "puts out a summary message" do
					expect{@cLoad.load}.to output(/Added: 2 and updated: 0 Artists/).to_stdout
				end
				it "updates artists" do
					@cLoad.load
					expect{@cLoad.load}.to change(Artist, :count).by(0)
				end
				it "puts out a summary message" do
					@cLoad.load
					expect{@cLoad.load}.to output(/Added: 0 and updated: 2 Artists/).to_stdout
				end
				it "adds record correctly" do
					@cLoad.load
					artist_name = "Allen Stone"
					artist_code = ArtistCode.extract(artist_name)
					artist = Artist.by_code_and_festival_id(artist_code,@festival_id).take
					expect(artist).to_not be_nil
					expect(artist.name).to eq artist_name
					expect(artist.code).to eq artist_code
					expect(artist.linkid).to eq "520"
					expect(artist.active).to be_truthy
					expect(artist.extractdate).to eq Date.parse("2016-01-23")
				end
			end	
		end
	end
end
