

class HeaderLine
	attr_reader :inputline, :data, :content
	attr_accessor :line_number
	
	class << self
		def has_keyword?(word)
			return true if word.upcase == "SCHEDULEDATE"
		end
	end
	
	def initialize(input_line)
		@line_number = 0
		@inputline = input_line
		@content = :header
		if self.valid?
			@data = input_line.split[1] 
		end
	end
	
	def valid?
		words = @inputline.split
		return false unless words.count > 1
		return false unless HeaderLine.has_keyword?(words[0])
		return true
	end		
end

class InvalidLine
	attr_reader :inputline, :data, :content
	attr_accessor :line_number
	
	def initialize(input_line)
		@line_number = 0
		@inputline = input_line
		@content = :invalid
	end
	def valid?
		false
	end	
end


class SkipLine
	attr_reader :inputline, :data, :content
	attr_accessor :line_number
	
	class << self
		def has_keyword?(word)
			word.strip!
			return true if word.strip == ""
			return true if word[0] == "#" 
			return true if word.upcase == "START"
		end
	end
	
	def initialize(input_line)
		@line_number = 0
		@inputline = input_line
		@content = :skip
	end
	def valid?
		true
	end	
end

class DayLine
	attr_reader :inputline, :data, :content
	attr_accessor :line_number
	
	class << self
		def has_keyword?(word)
			return true if word.upcase == "DAY"
		end
	end
		
	def initialize(input_line)
		@line_number = 0
		@inputline = input_line
		@content = :day
		if self.valid?
			@data = format_data(input_line)
		end
	end
	
	def valid?
		words = @inputline.split
		return false unless words.count > 1
		return false unless DayLine.has_keyword?(words[0])
		return false unless words[1] =~ /^\d+$/
		return false if words[1].to_i  < 1
		return true
	end		
	
	private

	def format_data(line)
		daynumber = line.split[1]
		return {:day => daynumber.to_i}
	end
end

class StageLine
	attr_reader :inputline, :data, :content
	attr_accessor :line_number
	
	class << self
		def has_keyword?(word)
			return true if word.upcase == "TIME"
		end
	end


	def initialize(input_line)
		@line_number = 0
		@inputline = input_line
		@content = :stage
		if self.valid?
			@data = format_data(input_line)
		end
	end
	
	def valid?
		words = @inputline.split
		return false unless words.count > 1
		return false unless StageLine.has_keyword?(words[0])
		return true
	end
	
	def format_data(line)
		#NB stage maybe more than one word
		words = line.split
		stage = words.slice(1,words.size).join(" ")
		return {:stage => stage}
	end

end

class PerformLine
	attr_reader :inputline, :data, :content
	attr_accessor :line_number
		
	class << self
		def has_keyword?(word)
			return true if word =~ /^(([0-1][0-9])|([2][0-3]))\.([0-5][0-9])$/
		end
	end


	def initialize(input_line)
		@line_number = 0
		#time , artist, duration
		@performance_line_match = /(\d{2}\.\d{2})([\s+\S+]+)(\s\d+\smin)([\s*\S*]*)/
		
		@inputline = input_line
		@content = :perform
		if self.valid?
			@data = format_data(input_line)
		end
	end
	
	def valid?
		words = @inputline.split
		return false unless words.count > 1
		return false unless PerformLine.has_keyword?(words[0])
		return false unless @inputline =~ @performance_line_match
		return true
	end
	
	def format_data(line)
		datamatch = @performance_line_match.match(@inputline.strip)
		starttime = datamatch[1]
		artist = datamatch[2].strip
		duration = datamatch[3].strip
		caption = datamatch[4].strip
		caption = artist if caption == ""
		starttime_formated = starttime.strip.sub(".",":")
		
		return {starttime: starttime_formated, artist: artist, duration: duration, caption: caption}
	end

end