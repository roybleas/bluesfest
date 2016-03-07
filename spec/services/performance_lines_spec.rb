require 'rails_helper'
require './app/services/performance_lines_service.rb'


RSpec.describe "extract performances services" do
	context "header line class" do
		it "creates header line class" do
			expect(HeaderLine.new("textline")).to_not be_nil
		end
		it "requires initialize with line string " do
			expect {line = HeaderLine.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "responds to valid? method" do
			expect(HeaderLine.new("")).to respond_to(:valid?)
		end
		it "returns invalid if no schedule header word provided" do
			inputline = "testone"
			expect(HeaderLine.new(inputline).valid?).to be_falsey
		end
		it "returns invalid if no schedule header data provided" do
			inputline = "ScheduleDate"
			expect(HeaderLine.new(inputline).valid?).to be_falsey
		end
		it "returns valid if schedule header and data provided" do
			inputline = "ScheduleDate thisdata"
			expect(HeaderLine.new(inputline).valid?).to be_truthy
		end
		it "has a line number attribute" do
			expect(HeaderLine.new("ScheduleDate thisdata").line_number).to eq(0)
		end
		it "has a line number attribute" do
			line = HeaderLine.new("ScheduleDate thisdata")
			line.line_number = 100
			expect(line.line_number).to eq(100)
		end

		it "returns empty string for data when invalid input line provided" do
			inputline = "thisdata"
			expect(HeaderLine.new(inputline).data).to be_nil
		end
		it 'returns valid regardless of key word case' do
			inputline = "sCHEDULEdATE thisdata"
			expect(HeaderLine.new(inputline).valid?).to be_truthy
		end
		it "returns input value in data method when tested for being valid" do 
			inputline = "ScheduleDate thisdata"
			expect(HeaderLine.new(inputline).data).to eq("thisdata")
		end
		it "returns content value of header" do 
			inputline = "ScheduleDate thisdata"
			expect(HeaderLine.new(inputline).content).to eq(:header)
		end
		it "returns valid and ignores spaces between schedule header and data provided" do
			inputline = "  ScheduleDate   thisdata   "
			expect(HeaderLine.new(inputline).valid?).to be_truthy
		end
		it "returns true to keyword Scheduledate" do
			expect(HeaderLine.has_keyword?("SCHEDULEDATE")).to be_truthy
		end
		it "ignores case for keyword Scheduledate" do
			expect(HeaderLine.has_keyword?("Scheduledate")).to be_truthy
		end
		it "returns false when keyword is not Scheduledate" do
			expect(HeaderLine.has_keyword?("Schedule date")).to be_falsey
		end
		

	end	

	context "invalid line class" do
		it "creates invalid line class" do
			expect(InvalidLine.new("textline")).to_not be_nil
		end
		it "requires initialize with line string " do
			expect {line = InvalidLine.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "responds to valid? method" do
			expect(InvalidLine.new("")).to respond_to(:valid?)
		end
		it "is never valid" do
			expect(InvalidLine.new("").valid?).to be_falsey
		end
		it "has content attribute invalid" do
			expect(InvalidLine.new("").content).to eq(:invalid)
		end	
	end			

	context "skip line class" do
		it "creates class" do
			expect(SkipLine.new("textline")).to_not be_nil
		end
		it "requires initialize with line string " do
			expect {line = SkipLine.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "responds to valid? method" do
			expect(SkipLine.new("")).to respond_to(:valid?)
		end
		it "is never valid" do
			expect(SkipLine.new("").valid?).to be_truthy
		end
		it "has content attribute skip" do
			expect(SkipLine.new("").content).to eq(:skip)
		end
		it "has keyword that empty string" do
			expect(SkipLine.has_keyword?(" ")).to be_truthy
		end		
		it "has keyword #" do
			expect(SkipLine.has_keyword?(" # ")).to be_truthy
		end
		it "has keyword that starts with #" do
			expect(SkipLine.has_keyword?(" #someword ")).to be_truthy
		end		
		it "has keyword Start" do
			expect(SkipLine.has_keyword?(" StArt ")).to be_truthy
		end		
		
	end	
			
	context "day line class" do
		it "creates class" do
			expect(DayLine.new("textline")).to_not be_nil
		end
		it "requires initialize with line string " do
			expect {line = DayLine.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "responds to valid? method" do
			expect(DayLine.new("")).to respond_to(:valid?)
		end
		it "has a line number attribute" do
			expect(DayLine.new("Day 1").line_number).to eq(0)
		end
		it "has a line number attribute" do
			line = DayLine.new("Day 1")
			line.line_number = 100
			expect(line.line_number).to eq(100)
		end	
		it "has content attribute day" do
			expect(DayLine.new("").content).to eq(:day)
		end
		it "is invalid if second word is not an integer" do
			expect(DayLine.new("DAY a").valid?).to be_falsey 
		end
		it "is invalid if second word starts without an integer" do
			expect(DayLine.new("DAY a2").valid?).to be_falsey 
		end
		it "is invalid if second word is not only an integer" do
			expect(DayLine.new("DAY 2a").valid?).to be_falsey 
		end
		it "is invalid if second word is an integer less than 1" do
			expect(DayLine.new("DAY 0").valid?).to be_falsey 
		end
		it "is valid if second word is only an integer" do
			expect(DayLine.new("DAY 23").valid?).to be_truthy
		end
		it "sets Data to return hash" do
			expect(DayLine.new("Day 2").data).to eq({:day => 2}) 
		end
		it "has keyword DAY" do
			expect(DayLine.has_keyword?("DAY")).to be_truthy
		end
		it "ignores case for keyword" do
			expect(DayLine.has_keyword?("dAy")).to be_truthy
		end
		it "returns false when keyword is not day" do
			expect(DayLine.has_keyword?("day1")).to be_falsey
		end

	end			
	
	context "stage line class" do
		it "creates class" do
			expect(StageLine.new("textline")).to_not be_nil
		end
		it "requires initialize with line string " do
			expect {line = StageLine.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "responds to valid? method" do
			expect(StageLine.new("")).to respond_to(:valid?)
		end
		it "has content attribute " do
			expect(StageLine.new("").content).to eq(:stage)
		end
		it "has a line number attribute" do
			expect(StageLine.new("Time Crossroads").line_number).to eq(0)
		end
		it "has a line number attribute" do
			line = StageLine.new("Time Crossroads")
			line.line_number = 100
			expect(line.line_number).to eq(100)
		end
		it "is valid if has a second word" do
			expect(StageLine.new("Time Crossroads").valid?).to be_truthy
		end
		it "sets Data to hash" do
			expect(StageLine.new("TIME Mojo").data).to eq({:stage => "Mojo"}) 
		end
		it "has keyword TIME" do
			expect(StageLine.has_keyword?("TIME")).to be_truthy
		end
		it "ignores case for keyword" do
			expect(StageLine.has_keyword?("tImE")).to be_truthy
		end
		it "returns false when keyword is not time" do
			expect(StageLine.has_keyword?("notTime")).to be_falsey
		end
	end
	
	context "performance line class" do
		it "creates class" do
			expect(PerformLine.new("textline")).to_not be_nil
		end
		it "requires initialize with line string " do
			expect {line = PerformLine.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
		end
		it "responds to valid? method" do
			expect(PerformLine.new("")).to respond_to(:valid?)
		end
		it "has content attribute " do
			expect(PerformLine.new("").content).to eq(:perform)
		end
		it "has keyword time value" do
			expect(PerformLine.has_keyword?("12.34")).to be_truthy
		end
			
		it "returns false when keyword is not a time value" do
			expect(PerformLine.has_keyword?("notTime")).to be_falsey
		end
		it "returns false when keyword is invalid time value format" do
			expect(PerformLine.has_keyword?("0123")).to be_falsey
			expect(PerformLine.has_keyword?("01:23")).to be_falsey
			expect(PerformLine.has_keyword?("1.23pm")).to be_falsey
			expect(PerformLine.has_keyword?("a07.54pm")).to be_falsey
		end
		it "returns false when keyword is invalid hour value" do
			expect(PerformLine.has_keyword?("31.34")).to be_falsey
			expect(PerformLine.has_keyword?("24.00")).to be_falsey
		end
		it "returns false when keyword is invalid minute value" do
			expect(PerformLine.has_keyword?("01.60")).to be_falsey
		end
		it "returns true when keyword is edge time cases" do
			expect(PerformLine.has_keyword?("00.01")).to be_truthy
			expect(PerformLine.has_keyword?("23.59")).to be_truthy
		end
		it "has a line number attribute" do
			expect(PerformLine.new("22.45 KENDRICK LAMAR 75 min").line_number).to eq(0)
		end
		it "has a line number attribute" do
			line = PerformLine.new("22.45 KENDRICK LAMAR 75 min")
			line.line_number = 100
			expect(line.line_number).to eq(100)
		end

		it "returns valid when has time and artist and duration" do
			expect(PerformLine.new("22.45            KENDRICK LAMAR 75 min ").valid?).to be_truthy
		end
		it "returns valid with inverted comma " do
			expect(PerformLine.new("22.00              D'ANGELO 120 min ").valid?).to be_truthy
		end
		it "returns valid with inverted comma " do
			expect(PerformLine.new("15.00     ST. PAUL & THE BROKEN BONES 75 min").valid?).to be_truthy
		end
		it "returns invalid with invalid duration" do
			expect(PerformLine.new("22.45            KENDRICK LAMAR 75min ").valid?).to be_falsey
		end
		it "returns invalid with missing duration" do
			expect(PerformLine.new("22.45            KENDRICK LAMAR ").valid?).to be_falsey
		end
		it "returns invalid with invalid duration" do
			expect(PerformLine.new("22.45            KENDRICK LAMAR 75  min ").valid?).to be_falsey
		end
		it "returns a data hash " do
			expect(PerformLine.new("22.45            KENDRICK LAMAR 75 min ").data).to \
			 													eq({starttime: "22:45",artist: "KENDRICK LAMAR", duration: "75 min", caption: "KENDRICK LAMAR" })
		end
		it "returns valid with caption after duration" do
			expect(PerformLine.new("20.50       JEFF MARTIN  60 min  JEFF MARTIN (THE TEA PARTY)     ").valid?).to be_truthy
		end
		it "returns a data hash" do
			expect(PerformLine.new("20.50       JEFF MARTIN  60 min  JEFF MARTIN (THE TEA PARTY)     ").data).to \
												eq({starttime: "20:50",artist: "JEFF MARTIN", duration: "60 min", caption:"JEFF MARTIN (THE TEA PARTY)"})
		end

	end

end