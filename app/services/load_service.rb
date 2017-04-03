require_relative 'load_artist_pages_service'
require 'csv'
require 'date'
require 'yaml'

class LoadFestival
  def initialize(filename)
      @file_pathname = filename
  end
    
  def load
    
    CSV.foreach(@file_pathname, {headers: :true}) do |row|
      
      festival_year = row["year"].strip
      
      festival = Festival.find_or_create_by(year: festival_year )
      festival.startdate = Date.parse(row["startdate"])
      festival.days = row["days"].to_i
      festival.scheduledate = Date.parse(row["scheduledate"])
      festival.year = festival_year
      festival.title = row["title"].strip
      festival.major = row["major"].to_i
      festival.minor = row["minor"].to_i
      festival.active = row["active"].strip.to_bool
            
      festival.save
      puts "Loaded festival #{festival.title} for #{festival.year}"
    end
    
  end
end

class CurrentFestival
  attr_reader :title, :startdate
  
  def initialize(filename)
    @file_pathname = filename
  end
  
  def load
    begin
      festival = YAML.load(File.open(@file_pathname))
      @title = festival[0]['title']
      @startdate = festival[0]['startdate']
    end
  end
  
  def festival
    if @title.nil? || @startdate.nil?
      puts "Error: No current festival data set"
    else
      this_festival = Festival.where("festivals.startdate = ? and festivals.title = ?",@startdate,@title).take
      return this_festival
    end
  end

  def output_festival_message
    puts "Loading for #{@title} at #{@startdate} ..."
  end 
end

class RecordCounter
  def initialize(type_of_records)
    @total_add = 0
    @total_update = 0
    @type_of_records = type_of_records.pluralize
  end
  def add_record
    @total_add += 1
  end
  def update_record
    @total_update += 1
  end
  def total_added
    return @total_add
  end
  def total_updated
    return @total_update
  end
  def print_totals
    return "Added: #{@total_add} and updated: #{@total_update} #{@type_of_records}"
  end
end

class ArtistCode
# By removing punctuation and spaces and lowering case create a simple identifier from artist's name  
  class << self
    def extract(artistname)
      artistname.gsub(/[ \&\'\,\"\.]/,"").downcase
    end
  end
end


class LoadArtistError < StandardError
end


class LoadArtists
  
  def initialize(filename, currentfestival)
      @file_pathname = filename
      @currentfestival = currentfestival
  end

  def load
    record_counter = RecordCounter.new('Artist')
    
    festival = @currentfestival.festival
    raise LoadArtistError,  "Festival database record not found" if festival.nil?
    
    extract_date = getValidExtractDate

    CSV.foreach(@file_pathname, {col_sep: "\t", headers: :true}) do |row|
      
      artist_linkid = row["id"].strip unless row["id"].nil? 
      
      #skip the first line info
      next if artist_linkid == "ExtractDate"

      artist_name = row["artist"].strip
      artist_code = ArtistCode.extract(artist_name)
  
      artist = Artist.by_code_and_festival_id(artist_code,festival.id).take   
      if artist.nil?
        artist = Artist.new
        
        artist.code = artist_code
        artist.festival_id = festival.id
        
        record_counter.add_record
      else
        record_counter.update_record
      end
      artist.name = artist_name
      artist.linkid = artist_linkid
      artist.active = true
      artist.extractdate = extract_date
      
      artist.save
    end
    
    puts record_counter.print_totals
    
  end
   
  private
  
  def getValidExtractDate
    
    f = File.open(@file_pathname)
    csv = CSV.new(f, {col_sep: "\t", headers: :true})
    
    first_line = csv.gets
    f.close
    
    raise LoadArtistError, "Missing artist file extract date" unless first_line['id'].strip == "ExtractDate"
    begin
      dt = Date.parse(first_line['artist'].strip)
    rescue ArgumentError => e
      raise LoadArtistError, "Invalid extract date in artist file" unless e.message.match(/invalid date/).nil?
      raise  
    end
    
    return dt
  end
      

end

class LoadStageError < StandardError
end

class LoadStages
  
  def initialize(filename, currentfestival)
      @file_pathname = filename
      @currentfestival = currentfestival
  end
  
  def load
    add_count = 0
    update_count = 0
  
    festival = @currentfestival.festival
    raise LoadStageError,  "Festival database record not found" if festival.nil?

    CSV.foreach(@file_pathname, {col_sep: "\t", headers: :true}) do |row|

      title = row["title"].strip
      seq = row["seq"].strip.to_i
      stage_code = row["code"].strip
      
      stage = Stage.by_code_and_festival_id(stage_code,festival.id).take    
      if stage.nil?
        stage = Stage.new
        stage.code = stage_code
        stage.festival_id = festival.id
        add_count += 1
      else
        update_count += 1
      end
      stage.title = title
      stage.seq = seq
      
      stage.save
    end
      
    puts "Added: #{add_count} and updated: #{update_count} Stages"
    
  end
end

class ValidateCodesError < StandardError
end

class ValidateCodes
  def initialize(festival)
    @festival = festival
  end
  
  def artists(array)  
    
    artistcodes = Artist.select('code').where('festival_id = ? and code in (?)' , @festival.id, array).all.to_a

    return true if array.count == artistcodes.count
    
    artistcodelist = artistcodes.map {|c| c.code }
    missingcodes = array - artistcodelist
    
    raise ValidateCodesError,  "Artist codes [ #{missingcodes.join(', ')} ] not pre-loaded"
  end

  def stages(array) 
    
    stagecodes = Stage.select('code').where('festival_id = ? and code in (?)' , @festival.id, array).all.to_a

    return true if array.count == stagecodes.count
  
    stagecodelist = stagecodes.map {|c| c.code }
    missingcodes = array - stagecodelist
    
    raise ValidateCodesError,  "Stage codes [ #{missingcodes.join(', ')} ] not pre-loaded"
  end

  
  def artist_code_list(array)
    
    return code_list('artistcode',array)
    
  end
  
  def stage_code_list(array)
    return code_list('stagecode',array)
  end
  
  private
  
  def code_list(codetype, array)
    code_list = Array.new()
      
    array.each {|row| code_list << row[codetype] }
    
    code_list.uniq!
    
    return code_list
  end 
end

class LoadPerformanceError < StandardError
end

class LoadPerformances
  
  def initialize(filename, currentfestival)
      @file_pathname = filename
      @festival = currentfestival
  end
  
  def load
    add_count = 0
    update_count = 0

    stages = Stage.by_festival(@festival).all
    raise LoadPerformanceError,  "No stage database records found" if stages.empty?
    
    save_headercode = ""
    
    CSV.foreach(@file_pathname, { headers: :true}) do |row|
      #day,stagecode,artistcode,starttime,duration,caption,headercode
      daynumber     = row["day"].strip.to_i
      stage_code    = row["stagecode"].strip
      artist_code   = row["artistcode"].strip
      starttime     = row["starttime"].strip
      duration      = row["duration"].strip
      title         = row["caption"].strip
      headercode    = row["headercode"].strip
      
      save_headercode = headercode
      
      stage = Stage.by_code_and_festival_id(stage_code,@festival.id).take   
      raise LoadPerformanceError,  "No stage database records found with code #{stage_code}" if stage.nil?
      
      artist = Artist.by_code_and_festival_id(artist_code,@festival.id).take    
      raise LoadPerformanceError,  "No artist database records found with code #{artist_code}" if artist.nil?
      
      performance = Performance.by_artist_stage_day_starttime_and_festival(artist.id,stage.id,daynumber,starttime,@festival.id).take
      if performance.nil?
        performance = Performance.new       
        
        performance.daynumber     = daynumber
        performance.starttime     = starttime
        performance.festival_id   = @festival.id
        performance.artist_id     = artist.id
        performance.stage_id      = stage.id                

        add_count += 1
      else
        update_count += 1
                
      end
      
      performance.duration        = duration
      performance.scheduleversion = headercode
      performance.title           = title

      performance.save
        
    end
    puts "Added: #{add_count} and updated: #{update_count} Performances"
    
    return save_headercode unless (add_count + update_count) == 0
    return nil
  end
  
  def remove_old_performances(headercode)
    
    performance_ids = Performance.where('festival_id = ? and scheduleversion <> ?',@festival.id,headercode).ids
    Performance.destroy(performance_ids)
  end
  
  def update_artists_to_active
    artist_ids = Performance.select('artist_id').distinct.where('festival_id = ?',@festival.id).all
    ids = artist_ids.map {|a| a.artist_id }
    Artist.where('festival_id = ?',@festival.id).update_all(active: false)
    Artist.where('id in(?)',ids).update_all(active: true)
  end
  
end
