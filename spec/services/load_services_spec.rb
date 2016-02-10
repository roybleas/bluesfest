require 'rails_helper'
require './app/services/load_service.rb'
require 'date'        

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
	
	context "current festival" do
		it "does not have a valid file name " do
			cCurrentFestival = CurrentFestival.new('invalid')
			expect{cCurrentFestival.load}.to raise_error(/No such file or directory/)
		end
		it "has corrupt yaml file" do
			cCurrentFestival = CurrentFestival.new('./spec/files/invalid.yml')
			expect{cCurrentFestival.load}.to raise_error(/mapping values are not allowed/)
		end			
		it "outputs a message to show current festival record" do
			filename = './spec/files/festival.yml'
			cCurrentFestival = CurrentFestival.new(filename)
			expect{ cCurrentFestival.load}.to output(/Loading for Bluesfest at 2016-03-24/).to_stdout
		end
		it "has correct attributes set" do
			filename = './spec/files/festival.yml'
			cCurrentFestival = CurrentFestival.new(filename)
			cCurrentFestival.load
			expect(cCurrentFestival.title).to eq "Bluesfest"
			expect(cCurrentFestival.startdate).to eq Date.parse("2016-03-24")
		end
		context "fetch festival id" do
			it "shows message when festival attributes not loaded" do
				filename = './spec/files/festival.yml'
				cCurrentFestival = CurrentFestival.new(filename)
				expect{cCurrentFestival.festival}.to output(/Error: No current festival data set/).to_stdout
			end
			it "returns nil festival id when festival does not exist" do
				filename = './spec/files/festival.yml'
				cCurrentFestival = CurrentFestival.new(filename)
				cCurrentFestival.load
				expect(cCurrentFestival.festival).to be_nil
			end
			context "festival ids exist" do
				before(:each) do
					filename = './spec/files/festival.yml'
					@cCurrentFestival = CurrentFestival.new(filename)
					@cCurrentFestival.load
				end
				it "current festival record does exist" do
					festival = festival = create(:festival, title: @cCurrentFestival.title, startdate: @cCurrentFestival.startdate)
					expect(@cCurrentFestival.festival).to eq(festival)
				end
				it "return nil when different start date" do
					festival = festival = create(:festival, title: @cCurrentFestival.title, startdate: "2015-04-05")
					expect(@cCurrentFestival.festival).to be_nil
				end
				it "return nil when different title" do
					festival = festival = create(:festival, title: "other festival", startdate: @cCurrentFestival.startdate)
					expect(@cCurrentFestival.festival).to be_nil
				end
			end
		end
	end
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
					expect{@cLoad.load}.to output(/Added: 2 and updated: 0 artists/).to_stdout
				end
				it "updates artists" do
					@cLoad.load
					expect{@cLoad.load}.to change(Artist, :count).by(0)
				end
				it "puts out a summary message" do
					@cLoad.load
					expect{@cLoad.load}.to output(/Added: 0 and updated: 2 artists/).to_stdout
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
