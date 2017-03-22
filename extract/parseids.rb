require 'nokogiri'
require 'open-uri'
require 'yaml'

# Extract artist ids from bluesfest website
artists = YAML.load(File.open('artists_src.yml'))
src_url = artists[0]['src']

f = File.new("extractArtists.csv",'w')

	# create a csv header
	f.puts "id\tartist"
	#extract html
	doc = Nokogiri::HTML(open(src_url))
	#find the div tags that are around the artist name 
	doc.xpath('//a').each do |anchor|
		
		if anchor['id'].to_s.match /ctl00_ContentPlaceHolder1_scheduleFeed_rptResults_ctl00_dlResults_ctl\d+_lnkMain/
			# get the child and extract the artist id from the href attribute
			c = anchor.children
	
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



