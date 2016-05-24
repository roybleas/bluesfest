
require './app/services/performance_lines_service.rb'

class ExtractPerformancesError < StandardError
end

class ExtractPerformances

	def initialize(festival)
		@festival = festival		
	end
	
	def process_file(inputfile)
		@inputfile = inputfile
			
		raise ExtractPerformancesError,  "Input file #{@inputfile} not found" unless File.exists?(inputfile)
				
		array = IO.readlines(inputfile)
		raise ExtractPerformancesError,  "Input file #{@inputfile} is empty" if array.empty?
		
		performances = read_lines(array) if has_header_record?(array[0])
		
		valid_performances = verify_lines(performances,@festival)
		
		return merge_lines_to_output(valid_performances)
	end
	
	def has_header_record?(firstline)
		
		line = InputLine.fromKeyword(firstline)
		raise ExtractPerformancesError,  "Input file #{@inputfile} has invalid header record" unless line.content == :header
		
		return true
	end	
	
	def read_lines(array)
		
		performanceList = Array.new()
		
		linecount = 1
		
		array.each do |row|
			
			line = InputLine.fromKeyword(row)
			if line.valid?
				line.line_number = linecount
				performanceList << line unless line.content == :skip
			else
				raise ExtractPerformancesError,  "Invalid line #{linecount} (#{line.inputline})"
			end
			
			linecount += 1
		end
		
		return performanceList
	end
	
	def verify_lines(array,festival)
		day_data = DayData.new(festival)
		stage_data = StageData.new(festival)
		perform_data = PerformData.new(festival)
		
		array.each do |line|
			day_data.verify(line)
			stage_data.verify(line)
			perform_data.verify(line)
		end
		return array
	end
	
	def merge_lines_to_output(array)
				
		merge = MergeLines.new(HeaderRow.new().array)
		
		array.each do |line|
			merge.add(line)	
		end
		
		return merge.merged_lines_array
	end
	
end

class ExtractPerformancesMergeLinesError < StandardError
end

class MergeLines
	def initialize(header_row = nil)
		@array = []
		@array << header_row unless header_row.nil?
		@header_code
		@stage_code
		@day_number
	end
	
	def add(line)
		
		if line.content == :perform
		 	
		 	has_row_requirments(line)
			
			#["day","stagecode","artistcode","starttime","duration","caption","headercode"]
		 	row = [@day_number, @stage_code, line.data[:code], line.data[:starttime],line.data[:duration], line.data[:caption], @header_code]

		 	@array << row
						
		elsif line.content == :stage
			@stage_code = line.data[:code]

		elsif line.content == :day
			@day_number = line.data[:day]	
		
		elsif line.content == :header
			@header_code = line.data
		end
	end
	
	def merged_lines_array
	
		return @array
	end
	
	private
	
	def create_row(line)
	end
	
	def has_row_requirments(line)
		raise ExtractPerformancesMergeLinesError, row_requirments_message(line,"header code") if @header_code.nil?	
		raise ExtractPerformancesMergeLinesError, row_requirments_message(line,"stage code") if @stage_code.nil?	
		raise ExtractPerformancesMergeLinesError, row_requirments_message(line,"day number") if @day_number.nil?	
	end

	def row_requirments_message(line,problem)
		return "Missing #{problem} when merging Line #{line.line_number} (#{line.inputline})"
	end
end

class InputLine
	class << self
	
		def fromKeyword(input_line)
			
			keyword = getFirstWord(input_line)
			
			if SkipLine.has_keyword?(keyword)
				thisline = SkipLine.new(input_line)

			elsif PerformLine.has_keyword?(keyword)
				thisline = PerformLine.new(input_line)

			elsif DayLine.has_keyword?(keyword)
				thisline = DayLine.new(input_line)

			elsif StageLine.has_keyword?(keyword)
				thisline = StageLine.new(input_line)

			elsif HeaderLine.has_keyword?(keyword)
				thisline = HeaderLine.new(input_line)
				
			else
				thisline = InvalidLine.new(input_line)
			end
			
			if thisline.valid?
				return thisline
			else
				return InvalidLine.new(input_line)
			end
		end
		
		def getFirstWord(input_line)
			line = input_line.strip.chomp
			words = line.split
			if words.count > 0 then
				firstword = words[0]
			else
				firstword = ""
			end
			return firstword
		end
	end
end

class DayData
	def initialize(festival)
		@festival = festival
	end
	
	def verify(line)
		return unless line.content == :day
		daynumber = line.data[:day]
		raise ExtractPerformancesError,"Invalid Festival day number at line #{line.line_number} (#{line.inputline})" unless daynumber <= @festival.days 
	end
end

class StageData
	def initialize(festival)
		@festival = festival
		@stages = Stage.by_festival(festival).all.to_a
	end
	
	def verify(line)
		return unless line.content == :stage
		stage_name = line.data[:stage].upcase
		stage = @stages.select {|s|  s["title"].upcase == stage_name}
		raise ExtractPerformancesError,"Invalid Stage name at line #{line.line_number} (#{line.inputline})" unless stage.count == 1 
		line.data.update({stage: stage[0].title, code: stage[0].code})
	end
end

class PerformData
	def initialize(festival)
		@festival = festival
		@artists = Artist.by_festival(festival).all.to_a
	end
	
	def verify(line)
		return unless line.content == :perform
		artist_name = line.data[:artist]
		artist_code = ArtistCode.extract(artist_name)
		artist = @artists.select {|a|  a["code"] == artist_code}
		raise ExtractPerformancesError,"Artist not found at line #{line.line_number} (#{line.inputline})" unless artist.count == 1 
		line.data.update({code: artist[0].code})
	end
end

class HeaderRow
	def array
		["day","stagecode","artistcode","starttime","duration","caption","headercode"]
	end
end