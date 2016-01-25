require 'nokogiri'
require 'open-uri'

# Extract artist ids from bluesfest website
src_url = "http://www.bluesfest.com.au/schedule/?DayID=89"

f = File.new("extractArtists2.csv",'w')

	# create a csv header
	f.puts "id\tartist"
	#extral html
	doc = Nokogiri::HTML(open(src_url))
	#find the div tags that are around the artist name 
	doc.xpath('//a').each do |anchor|
		
		if anchor['id'].to_s.match /ctl00_ContentPlaceHolder1_scheduleFeed_rptResults_ctl00_dlResults_ctl\d+_lnkMain/
			# get the child and extract the artist id from the href attribute
			#puts anchor['id'].to_s
			#puts anchor['href'].to_s
			c = anchor.children
			#puts c.inspect
			
			#id = a.attr('href').to_s.sub('detail.aspx?ArtistID=','')
			id = anchor['href'].to_s.sub('detail.aspx?ArtistID=','')
			
			# get the artist name from the header tag
			artist = c.css('h3')
			
			#put them together with a tab for csv file			
			artistid = id + "\t" + artist.text.strip
			f.puts artistid
			
			#show feed back on the screen
			puts artistid
			
		end
		
	end
f.close



