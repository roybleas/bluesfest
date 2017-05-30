require 'rails_helper'
require './app/services/extract_performances_service.rb'
require './app/services/load_service.rb'


RSpec.describe "extract performances services" do
  context "extract performances" do
    before(:each) do
      @festival = build(:festival)
    end
    it "has 1 argument" do
      expect {extract = ExtractPerformances.new() }.to raise_error(ArgumentError,/wrong number of arguments/)
    end
    it "process file has 1 argument" do
      expect {extract = ExtractPerformances.new(@festival).process_file() }.to raise_error(ArgumentError,/wrong number of arguments/)
    end
    context "Open file and get array" do
      it "raises error as input file does not exist" do
        expect {extract = ExtractPerformances.new(@festival).process_file("notafile")}.to raise_error(/file notafile not found/)
      end
      it "reads an empty file and raise an error" do
        filename = './spec/files/emptyfile.txt'
        expect {ExtractPerformances.new(@festival).process_file(filename)}.to raise_error("Input file #{filename} is empty")
      end
      it "reads a file with invalid header and raises error" do
        filename = './spec/files/performanceswithoutheader.txt'
        expect {ExtractPerformances.new(@festival).process_file(filename)}.to raise_error("Input file #{filename} has invalid header record")
      end
      context "reads file with valid header record and sample performances" do 
        before(:each) do      
          @festival = create(:festival)
          s1 = create(:stage,festival_id: @festival.id)
          s2 = create(:stage,festival_id: @festival.id, title: "Crossroads", code: "cr")
          a1 = create(:artist, festival_id: @festival.id, name: "KENDRICK LAMAR", code: "kendricklamar" )
          a2 = create(:artist, festival_id: @festival.id, name: "D'ANGELO", code: "dangelo" )
          a3 = create(:artist, festival_id: @festival.id, name: "KAMASI WASHINGTON", code: "kamasiwashington" )
          a4 = create(:artist, festival_id: @festival.id, name: "TEDESCHI TRUCKS BAND", code: "tedeschitrucksband" )
          a5 = create(:artist, festival_id: @festival.id, name: "TWEEDY", code: "tweedy" )
        end
        it 'with data format 1' do
          filename = './spec/files/validperformances1.txt'
          expect {ExtractPerformances.new(@festival).process_file(filename)}.to_not raise_error
        end
        it 'with data format 2' do
          filename = './spec/files/validperformances2.txt'
          extract_performances = ExtractPerformances.new(@festival)
          extract_performances.performance_data_format = 2
          expect {extract_performances.process_file(filename)}.to_not raise_error
        end

      end
    end
    context "optional performance data formats" do
      it "default performance format is nil" do
        expect(ExtractPerformances.new(@festival).performance_data_format).to be_nil
      end
      it "can be set to 2" do
        extract = ExtractPerformances.new(@festival)
        extract.performance_data_format = 2 
        expect(extract.performance_data_format).to eq(2)
      end
    end
    context "read array " do
      it "ignores a blank line " do
        array = ["    "]
        expect(ExtractPerformances.new(@festival).read_lines(array)).to be_empty
      end
      it "ignores a comment line " do
        array = [" #stuff   "]
        expect(ExtractPerformances.new(@festival).read_lines(array)).to be_empty
      end
      it "ignores a START line " do
        array = [" START   "]
        expect(ExtractPerformances.new(@festival).read_lines(array)).to be_empty
      end
      it "extracts a Header line" do
        array = [" SCHEDULEDATE 20160219   "]
        expect(ExtractPerformances.new(@festival).read_lines(array)[0]).to be_kind_of(HeaderLine)       
      end
      it "extracts a day line" do
        array = [" DAY  1   THURSDAY 24TH   "]
        line = ExtractPerformances.new(@festival).read_lines(array)[0]
        expect(line).to be_kind_of(DayLine)       
        expect(line.line_number).to eq(1)
      end
      it "extracts a stage line" do
        array = [" TIME            CROSSROADS    "]
        expect(ExtractPerformances.new(@festival).read_lines(array)[0]).to be_kind_of(StageLine)        
      end
      it "extracts a perform line" do
        array = ["17.15          BLIND BOY PAXTON 45 min "]
        expect(ExtractPerformances.new(@festival).read_lines(array)[0]).to be_kind_of(PerformLine)        
      end
      context "on invalid lines" do
        it "raises error on line.valid? is false" do
          array = ["Invalid keyword and stuff"]
          expect {ExtractPerformances.new(@festival).read_lines(array)}.to raise_error("Invalid line 1 (Invalid keyword and stuff)")
        end
        it "has the correct line number in error mesage" do
          array = [" "," ","Invalid keyword and stuff", " "]
          expect {ExtractPerformances.new(@festival).read_lines(array)}.to raise_error("Invalid line 3 (Invalid keyword and stuff)")
        end
      end
    end
    context "verify day line" do
      it "raises an error when invalid day created" do
        festival = build(:festival)
        d = DayLine.new("Day 6")
        d.line_number = 1
        array = [d]
        expect{ExtractPerformances.new(festival).verify_lines(array,festival)}.to raise_error("Invalid Festival day number at line 1 (Day 6)")
      end
      it "does not raise an error when valid day created" do
        festival = build(:festival)
        d = DayLine.new("Day 5")
        d.line_number = 1
        array = [d]
        expect{ExtractPerformances.new(festival).verify_lines(array,festival)}.to_not raise_error
      end
    end
    context "merge_lines_to_output" do
      before(:context) do
        @festival = build(:festival)
      end
      it "creates a header row" do
        array = Array.new
        expect(ExtractPerformances.new(@festival).merge_lines_to_output(array)).to match_array ([HeaderRow.new().array])
      end
    end

  end
  context "Configuration class" do
    it "extracts file suffix from yaml" do
      config = ConfigurationForExtract.new('./spec/files/performance_config.yml')
      expect(config.file_suffix).to eq('20170310')
      expect(config.performance_data_format).to eq(2)
    end
  end
  
  context "InputLine class" do
    
    it "returns Header Line object when passed valid header input line" do
      inputline = "scheduledate somedata"
      expect(InputLine.new().fromKeyword(inputline)).to be_kind_of(HeaderLine)
    end
    it "returns Invalid Line object when passed invalid header input line" do
      inputline = "scheduledate"
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(InvalidLine)
    end
    it "returns a skipline when input blank" do
      inputline = " "
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(SkipLine)
    end
    it "returns a skipline when input starts with #" do
      inputline = " # "
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(SkipLine)
    end
    it "returns a skipline when input starts with START" do
      inputline = " Start "
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(SkipLine)
    end

    it "returns a dayline when input starts with Day " do
      inputline = " DAY 2"
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(DayLine)
    end
    it "returns a stageline when input starts with Time " do
      inputline = " TIME stuff"
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(StageLine)
    end
    it "returns a performanceline when input starts with a time value " do
      inputline = " 12.34 stuff 12 min"
      expect(InputLine.new.fromKeyword(inputline)).to be_kind_of(PerformLine)
    end
    context "performance format 2" do
      it "returns a performanceline when input starts with a time value but has no mins duration" do
        inputline = " 12.34 stuff "
        input_line = InputLine.new
        input_line.performance_data_format = 2
        expect(input_line.fromKeyword(inputline)).to be_kind_of(PerformLine_2)
      end
    end
    context "performance format 3" do
      it "returns a performanceline when input starts with a time value and a performance caption in brackets" do
        inputline = " 12.34 artist name [ caption stuff ] "
        input_line = InputLine.new
        input_line.performance_data_format = 3
        perform_line = input_line.fromKeyword(inputline)
        expect(perform_line).to be_kind_of(PerformLine_3)
        expect(perform_line.data[:starttime]).to eq('12:34')
        expect(perform_line.data[:artist]).to eq('artist name')
        expect(perform_line.data[:caption]).to eq('caption stuff')
      end
      it "returns a performanceline when input starts with a time value and without a performance caption in brackets" do
        inputline = " 17.28 only artist name "
        input_line = InputLine.new
        input_line.performance_data_format = 3
        perform_line = input_line.fromKeyword(inputline)
        expect(perform_line).to be_kind_of(PerformLine_3)
        expect(perform_line.data[:starttime]).to eq('17:28')
        expect(perform_line.data[:artist]).to eq('only artist name')
        expect(perform_line.data[:caption]).to eq('only artist name')
      end

    end

  end

  context "validate day line against festival" do
    before(:each) do
      @festival = build(:festival)
    end
    it "has a DayLine class" do
      expect(DayData.new(@festival)).to_not be_nil
    end
    it "ignore non dayline objects" do
      expect(DayData.new(@festival).verify(StageLine.new("Time Crossroads"))).to be_nil
    end   
    it "verify dayline objects" do
      expect(DayData.new(@festival).verify(DayLine.new("Day 2 "))).to be_nil
    end   
    it "raise error if day number invalid" do
      line = DayLine.new("Day 6 ")
      line.line_number = 3 
      expect{DayData.new(@festival).verify(line)}.to raise_error("Invalid Festival day number at line 3 (Day 6 )")
    end   
  end
  context "validate stage line against stages " do
    before(:each) do
      @festival = create(:festival_with_stages)
    end
    it "has a StageLine data class" do
      expect(StageData.new(@festival)).to_not be_nil
    end
    it "ignore non stageline objects" do
      expect(StageData.new(@festival).verify(DayLine.new("Day 1"))).to be_nil
    end
    it "raise error if stage title not found" do
      line = StageLine.new("Time NotAStage ")
      line.line_number = 4
      expect{StageData.new(@festival).verify(line)}.to raise_error("Invalid Stage name at line 4 (Time NotAStage )")
    end   
    it "updates stageline object with code" do
      line = StageLine.new("TIME             JUKE JOINT  ")
      StageData.new(@festival).verify(line)
      expect(line.data).to eq ({stage: "Juke Joint", code: "ju"})  
    end   
    it "ignores case of stage title when updating" do
      line = StageLine.new("TIME CrOsSroads ")
      StageData.new(@festival).verify(line)
      expect(line.data).to eq ({stage: "Crossroads", code: "cr"})  
    end   
  end
  context "validate perform line against artists " do
    before(:each) do
      @festival = create(:festival)
      a1 = create(:artist, festival_id: @festival.id, active: true)
      a2 = create(:artist, festival_id: @festival.id, active: true, name: "KENDRICK & LAMAR",code: "kendricklamar" )
    end
    it "has a PerformLine data class" do
      expect(PerformData.new(@festival)).to_not be_nil
    end   
    it "ignore non Performline objects" do
      expect(PerformData.new(@festival).verify(DayLine.new("Day 1"))).to be_nil
    end
    it "raise error if artist code not found" do
      line = PerformLine.new("19.15 No Name Artist 20 min")
      line.line_number = 4
      expect{PerformData.new(@festival).verify(line)}.to raise_error("Artist not found at line 4 (19.15 No Name Artist 20 min)")
    end   
    it "updates Performline object with code" do
      line = PerformLine.new("22.45    KENDRICK & LAMAR  75 min")
      PerformData.new(@festival).verify(line)
      expect(line.data).to eq ({starttime: "22:45",artist: "KENDRICK & LAMAR", duration: "75 min", caption: "KENDRICK & LAMAR", code: "kendricklamar"})  
    end   
  end
  context "Header Row" do
    it "returns default array" do
      expect(HeaderRow.new().array).to match_array(["day","stagecode","artistcode","starttime","duration","caption","headercode"])
    end
  end
  context "MergeLines" do
    it "can create a MergeLines object" do
      expect(MergeLines.new()).to_not be_nil
    end
    context "validates all data exists before creating row" do
      before(:example) do
        @inputline = "22.45    KENDRICK LAMAR  75 min"
        @performline = PerformLine.new(@inputline)
        @performline.line_number = 2
      end
      it "raises an error if attempts to merge without header" do
        expect{MergeLines.new().add(@performline)}.to raise_error("Missing header code when merging Line 2 (#{@inputline})")        
      end
      it "raises an error if attempts to merge without stage" do
        merge = MergeLines.new()
        merge.add(HeaderLine.new("scheduledate testdata"))
        expect{merge.add(@performline)}.to raise_error("Missing stage code when merging Line 2 (#{@inputline})")        
      end
      it "raises an error if attempts to merge without day" do
        merge = MergeLines.new()
        merge.add(HeaderLine.new("scheduledate testdata"))
        sl = StageLine.new("Time testdata")
        sl.data.update({code: "xy"})
        merge.add(sl)
        expect{merge.add(@performline)}.to raise_error("Missing day number when merging Line 2 (#{@inputline})")        
      end
      it "does not raise an error when all values set" do
        merge = MergeLines.new()
        merge.add(HeaderLine.new("scheduledate testdata"))
        dl = DayLine.new("Day 2")
        merge.add(dl)
        sl = StageLine.new("Time testdata")
        sl.data.update({code: "xy"})
        merge.add(sl)
        expect{merge.add(@performline)}.to_not raise_error
      end
    end
    context "header row" do
      it "has now header line" do
        merge = MergeLines.new()
        expect(merge.merged_lines_array).to be_empty
      end
      it "has a header line" do
        merge = MergeLines.new(HeaderRow.new().array)
        expect(merge.merged_lines_array).to match_array([HeaderRow.new().array])
      end
    end
    context "add performance line" do
      before(:example) do
        inputline = "22.45    KENDRICK LAMAR  75 min"
        performline = PerformLine.new(inputline)
        performline.data.update({code: "kendricklamar"})
        @merge = MergeLines.new()
        @merge.add(HeaderLine.new("scheduledate testdata"))
        dl = DayLine.new("Day 2")
        @merge.add(dl)
        sl = StageLine.new("Time somedata")
        sl.data.update({code: "xy"})
        @merge.add(sl)
        @merge.add(performline)
      end
      it " adds a row" do
        expect(@merge.merged_lines_array).to match_array([[2,"xy","kendricklamar","22:45","75 min","KENDRICK LAMAR", "testdata"]])
      end
      it "updates stage and adds a performance" do
        sl = StageLine.new("Time someotherdata")
        sl.data.update({code: "ab"})
        @merge.add(sl)
        inputline = "18.45       THE WAILERS 100 min THE WAILERS PRESENT LEGEND"
        pl = PerformLine.new(inputline)
        pl.data.update({code: "thewailers"})
        @merge.add(pl)
        expect(@merge.merged_lines_array).to include([2,"ab","thewailers","18:45","100 min","THE WAILERS PRESENT LEGEND","testdata"])
      end
      it "updates day number and adds a performance" do
        dl = DayLine.new("Day 3 ")
        @merge.add(dl)
        inputline = "19.00    KAMASI WASHINGTON 60 min"
        pl = PerformLine.new(inputline)
        pl.data.update({code: "kamasiwashington"})
        @merge.add(pl)
        expect(@merge.merged_lines_array).to include([3,"xy","kamasiwashington","19:00","60 min","KAMASI WASHINGTON","testdata"])
      end
    end   
  end
end