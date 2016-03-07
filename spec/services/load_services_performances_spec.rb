require 'rails_helper'
require './app/services/load_service.rb'
      

RSpec.describe "load services" do

	context "Validate Artists" do
		before(:context) do
			@festival = build(:festival)
		end
		it "creates class" do
			expect(ValidateCodes.new(@festival)).to_not be_nil
		end
		it "requires initialize with a festival " do
			expect {ValidateCodes.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "reads a csv array of artist codes to verify"  do
			array = []
			expect(ValidateCodes.new(@festival).artists(array)).to be_truthy
		end
	end
	context "list of artists codes from csv" do
		before(:example) do
			@festival = create(:festival)
		end
		it "returns an artist code in an array" do
			csv = "day,stagecode,artistcode,starttime,duration,caption,headercode\n5,mo,tomjones,20:45,90 min,TOM JONES,20160304"				
			array = CSV.parse(csv,{headers: true})
			expect(ValidateCodes.new(@festival).artist_code_list(array)).to eq (%w[tomjones])
		end
		it "returns multiple artist codes in an array" do
			csv = "day,stagecode,artistcode,starttime,duration,caption,headercode\n4,mo,tomjones,20:45,90 min,TOM JONES,20160304\n1,mo,kendricklamar,22:45,75 min,KENDRICK LAMAR,20160304"				
			array = CSV.parse(csv,{headers: true})
			expect(ValidateCodes.new(@festival).artist_code_list(array)).to eq (%w[tomjones kendricklamar])
		end
		it "returns multiple unique artist codes in an array" do
			csv = "day,stagecode,artistcode,starttime,duration,caption,headercode\n4,mo,tomjones,20:45,90 min,TOM JONES,20160304\n1,mo,kendricklamar,22:45,75 min,KENDRICK LAMAR,20160304\n5,cr,tomjones,17:45,90 min,TOM JONES,20160304"				
			array = CSV.parse(csv,{headers: true})
			expect(ValidateCodes.new(@festival).artist_code_list(array)).to eq (%w[tomjones kendricklamar])
		end

	end
	context "look up artist codes" do
		before(:example) do
				@festival = create(:festival)
		end
		it "returns true if artistcode exists in database" do
			a = create(:artist, festival_id: @festival.id)
			array = %w[tomjones]
			expect(ValidateCodes.new(@festival).artists(array)).to be_truthy
		end
		it "raises error when artists table is empty" do
			array = %w[tomjones]
			expect{ValidateCodes.new(@festival).artists(array)}.to raise_error("Artist codes [ tomjones ] not pre-loaded") 
		end
		it "raises error when artist code not found in table" do
			a = create(:artist, festival_id: @festival.id)
			array = %w[gracepotter]
			expect{ValidateCodes.new(@festival).artists(array)}.to raise_error("Artist codes [ gracepotter ] not pre-loaded") 
		end
		it "raises error when multiple artist codes not found in table" do
			a = create(:artist, festival_id: @festival.id)
			array = %w[elleking tomjones gracepotter]
			expect{ValidateCodes.new(@festival).artists(array)}.to raise_error("Artist codes [ elleking, gracepotter ] not pre-loaded") 
		end
		it "returns true if multiple artistcode exists in database" do
			a = create(:artist, festival_id: @festival.id)
			a = create(:artist, festival_id: @festival.id, code: 'elleking', name: 'Elle King')
			a = create(:artist, festival_id: @festival.id, code: 'gracepotter', name: 'Grace Potter')
			array = %w[tomjones gracepotter elleking]
			expect(ValidateCodes.new(@festival).artists(array)).to be_truthy
		end
	end
	
	context "list of stage codes from csv" do
		before(:example) do
			@festival = create(:festival)
		end
		it "returns a stage code in an array" do
			csv = "day,stagecode,artistcode,starttime,duration,caption,headercode\n5,mo,tomjones,20:45,90 min,TOM JONES,20160304"				
			array = CSV.parse(csv,{headers: true})
			expect(ValidateCodes.new(@festival).stage_code_list(array)).to eq (%w[mo])
		end
		it "returns multiple stage codes in an array" do
			csv = "day,stagecode,artistcode,starttime,duration,caption,headercode\n4,mo,tomjones,20:45,90 min,TOM JONES,20160304\n1,cr,kendricklamar,22:45,75 min,KENDRICK LAMAR,20160304"				
			array = CSV.parse(csv,{headers: true})
			expect(ValidateCodes.new(@festival).stage_code_list(array)).to eq (%w[mo cr])
		end
		it "returns multiple unique stage codes in an array" do
			csv = "day,stagecode,artistcode,starttime,duration,caption,headercode\n4,mo,tomjones,20:45,90 min,TOM JONES,20160304\n1,mo,kendricklamar,22:45,75 min,KENDRICK LAMAR,20160304\n5,cr,tomjones,17:45,90 min,TOM JONES,20160304"				
			array = CSV.parse(csv,{headers: true})
			expect(ValidateCodes.new(@festival).stage_code_list(array)).to eq (%w[mo cr])
		end
	end
	context "look up stage codes" do
		before(:example) do
				@festival = create(:festival)
		end
		it "returns true if stage code exists in database" do
			a = create(:stage, festival_id: @festival.id)
			array = %w[mo]
			expect(ValidateCodes.new(@festival).stages(array)).to be_truthy
		end
		it "raises error when stage table is empty" do
			array = %w[mo]
			expect{ValidateCodes.new(@festival).stages(array)}.to raise_error("Stage codes [ mo ] not pre-loaded") 
		end
		it "raises error when stage code not found in table" do
			a = create(:stage, festival_id: @festival.id)
			array = %w[cr]
			expect{ValidateCodes.new(@festival).stages(array)}.to raise_error("Stage codes [ cr ] not pre-loaded") 
		end
		it "raises error when multiple artist codes not found in table" do
			a = create(:stage, festival_id: @festival.id)
			array = %w[cr ju ja]
			expect{ValidateCodes.new(@festival).stages(array)}.to raise_error("Stage codes [ cr, ju, ja ] not pre-loaded") 
		end
		it "returns true if multiple stagecode exists in database" do
			a = create(:stage, festival_id: @festival.id)
			a = create(:stage, festival_id: @festival.id, code: 'cr', title: 'Crossroads')
			a = create(:stage, festival_id: @festival.id, code: 'ju', title: 'Juke Joint')
			array = %w[cr mo ju]
			expect(ValidateCodes.new(@festival).stages(array)).to be_truthy
		end
	end

	context "Load performances" do
		context "with valid festival record" do
			before(:example) do
				@festival = create(:festival)
				@cLoad = LoadPerformances.new(@csv_filename,@festival)
			end
			it "raises error when stage records not found " do				
				expect{@cLoad.load}.to raise_error(/No stage database records found/)
			end
		end
		context "valid stage records" do
			before(:example) do
				@festival = create(:festival_with_stages,stage_count: 2)
				@csv_filename = './spec/files/scheduleexample1.csv'
				@cLoad = LoadPerformances.new(@csv_filename,@festival)
				@artist = create(:artist, name: 'Kendrick Lamar', code: 'kendricklamar', festival_id: @festival.id)
			end
			it "raises error when performances file not found " do
				cLoad = LoadPerformances.new("invalid",@festival) 
				expect{cLoad.load}.to raise_error(/No such file or directory/)
			end		
			it "adds a performance" do
				expect{@cLoad.load}.to change(Performance, :count).by(1)
			end
			it "updates a performance" do
				stage = Stage.where(code: 'mo').first
				performance = create(:performance, festival_id: @festival.id,stage_id: stage.id, artist_id: @artist.id, starttime: '22:45',daynumber: 1, scheduleversion: 'testdata', duration: '10 min') 
				expect{@cLoad.load}.to change(Performance, :count).by(0)
				p = Performance.first
				expect(p.scheduleversion).to eq('20160304')
				expect(p.duration).to eq('75 min')
			end
			it "puts out a summary message" do
				stage = Stage.where(code: 'mo').first
				performance = create(:performance, festival_id: @festival.id,stage_id: stage.id, artist_id: @artist.id, starttime: '22:45',daynumber: 1, scheduleversion: 'testdata', duration: '10 min') 
				artist1 = create(:artist, name: 'Grace Potter', code: 'gracepotter', festival_id: @festival.id)
				artist2 = create(:artist, festival_id: @festival.id)
				csv_filename = './spec/files/scheduleexample2.csv'
				cLoad = LoadPerformances.new(csv_filename,@festival)
				expect{cLoad.load}.to output(/Added: 2 and updated: 1 Performances/).to_stdout
			end
			it "returns performance header code when at least one added" do
				expect(@cLoad.load).to eq("20160304")
			end
			it "returns nil header code when empty file" do
				csv_filename = './spec/files/emptyfile.txt'
				cLoad = LoadPerformances.new(csv_filename,@festival)
				expect(cLoad.load).to be_nil
			end

		end
	end
	
	context "delete out of date performances" do
		before(:example) do
			@festival = create(:festival)
		end
		
		it "has one performance not matching new schedule code" do
			performance = create(:performance, festival_id: @festival.id)
			cLoad = LoadPerformances.new("",@festival) 
			expect{cLoad.remove_old_performances('testdata')}.to change(Performance, :count).by(-1)
		end	
		it "has one performance notupdated and one to be deleted" do
			performance = create(:performance, festival_id: @festival.id)
			performance = create(:performance, festival_id: @festival.id, scheduleversion: 'testdata')
			cLoad = LoadPerformances.new("",@festival) 
			expect{cLoad.remove_old_performances('testdata')}.to change(Performance, :count).by(-1)
		end	
		it "has no performances not updated" do
			performance = create(:performance, festival_id: @festival.id, scheduleversion: 'testdata')
			performance = create(:performance, festival_id: @festival.id, scheduleversion: 'testdata')
			cLoad = LoadPerformances.new("",@festival) 
			expect{cLoad.remove_old_performances('testdata')}.to change(Performance, :count).by(0)
		end	
		it "does not delete from different festival performances" do
			other_festival = create(:festival)
			performance = create(:performance, festival_id: other_festival.id, scheduleversion: 'otherdata')
			performance = create(:performance, festival_id: @festival.id, scheduleversion: 'testdata')
			performance = create(:performance, festival_id: @festival.id, scheduleversion: 'otherdata')
			cLoad = LoadPerformances.new("",@festival) 
			expect{cLoad.remove_old_performances('testdata')}.to change(Performance, :count).by(-1)
		end	
	end
	context "artists active for existing performances " do
		before(:example) do
			@festival = create(:festival)
			@artist = create(:artist, festival_id: @festival.id, active:false)
			performance = create(:performance, festival_id: @festival.id, artist_id: @artist.id)

		end
		it "updates artist linked to current performances" do
			cLoad = LoadPerformances.new("",@festival) 
			cLoad.update_artists_to_active
			expect(Artist.find(@artist.id).active).to be_truthy
		end
		it "updates artist linked to current performances" do
			other_festival = create(:festival)
			artist = create(:artist, festival_id: other_festival.id, active:true)
			cLoad = LoadPerformances.new("",@festival) 
			cLoad.update_artists_to_active
			expect(Artist.find(artist.id).active).to be_truthy
		end
		it "sets to false artist not linked to current performances" do
			artist = create(:artist, festival_id: @festival.id, active:true)
			cLoad = LoadPerformances.new("",@festival) 
			cLoad.update_artists_to_active
			expect(Artist.find(artist.id).active).to be_falsey
		end

	end
end