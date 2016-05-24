## Bluesfest planner

### [Bluesfest](http://www.bluesfest.com.au) is a Blues & Roots Music Festival held each year near Byron Bay

#### Background
The music festival has over 80 musicians/bands on 5 stages over 5 days. With so many performances, choosing which artists to see on which days requires some planning. The phone app provided by Bluesfest allows you to create a wish list by performance, but not by artist. This is a typical feature amongst other similar festival applications. It is a lot easier to associate the user with a performance. Yet most artists at the Bluesfest play on more than one day and sometimes on 3 or 4 days. So rather than create a wish list of individual performances, I first want to create a list of artists. Then juggle the performance times so I can see as many of them as possible.  

While at the festival I also want to be able to keep track of my personal schedule on my phone. So I can be at the correct stage at the correct time. It is also important to be able to easily look up a list of performances. 

#### Features
* View the Bluesfest schedule by
  * performances by time on all stages for a particular day - not suitable for small device 
  * performances by stage for a particular day - suitable for small device
* View Artists  
  * as a list
  * as single artist with performances
  * with a link to artist's web page at Bluesfest web site 
* At the Home Page   
  * Prior to festival starting, view a countdown in days to it commencing
  * During festival view:
    * Who is currently on stage
    * Who will appearing on stage next
    * Users personal schedule for the day when logged on
    * A friendly greeting after the festival has finished.   
* Create a user and sign on
* When logged in
  * Create a list of favourite artists
  * Add and remove favourite performances from personal schedule
  * View personal daily schedule
* Admin user
  * View all users
  * Delete user
  * Reset user password  
  
### Setting a day and time during the festival for testing
An important feature of the application is to be able to see your daily schedule during the festival, and also to show who is currently on stage and who is playing next. A set of routes exists to allow you to override the actual current time and date with a session time and festival date.   
As this is designed for testing there are no validations on the data entered. Using invalid day, hours or miniutes will generate an error.
   
#### __settime__   
* Sets the day (festival day number for the current festival) , hour (24) and minute using the route  
  `settime/:day/:hr/:min`    
  
  eg 'settime/4/19/45' for the year 2016
  would create a test time of Sun 27 Mar 2016 07:45 PM   
  
#### __reset__
* Cancels the test time and reverts to server time  
	 `reset` 
	
#### __showtime__
* Shows the current session test date and time if one is set and the current server date and time. 	
  `showtime`

  
### Seed Data
The seeds.rb file contains data to create a user with admin attribute set to true enabling access to Admin menu . 
 
### Data 
There are 2 sources of data taken from the festival website

* [The Playing Schedule](http://www.bluesfest.com.au/pages/?ParentPageID=90&PageID=177)
* [Line up 2016](http://www.bluesfest.com.au/schedule/?DayID=89)

Other data used to populate the database is extrapolated from these sources. 

### Artists Data
The artists table data is extracted by parsing the artist 'Line Up' page from the Bluesfest webpage. 
The web address is currently hard coded into the program and needs to be configured as a parameter.
The extract program `parseids2.rb` extracts the name of the artist and the id used to access their page on the website, and writes to a CSV file extractArtists2.csv.

* __Extract program__  extract/parseids2.rb
* __Output File:__		extractArtists2.csv
* __Delimiter:__ tab
* Header row has  columns:

 | column       | description |
 | ------       | ----------- |
 | id     | The id used to identify artist web page bio on Bluesfest web site. If the artist does not have a link to a dedicated web page then the id value is left empty |
 | artist | Name of the artist |		
 
 
##### Manual Data Updates:

* Replace double quotations with a single quote   
eg.   
Replace `Eugene "Hideaway" Bridges` with `Eugene 'Hideaway' Bridges`   
* Insert the date the file data was extracted after header, setting id = 'ExtractDate' and artist = date in format yyyy-mm-dd delimited with a tab.  
eg.   

`ExtractDate	2016-03-04` 

Example data

```csv 
id	artist
ExtractDate	2016-03-04
	ABC Gold Coast FM National Broadcast
520	Allen Stone
793	Archie Roach
774	D'Angelo    
816	Digging Roots
644	Eugene 'Hideaway' Bridges
```
* To-do: 
  * Automatically insert todays date when creating output file.
  * Convert double quotes to single quotation mark
  * Task to copy `extract/extractArtists2.csv` to `db/dbloadfiles/artists.csv`  
  
### Performance Data
The performance data is extracted from the published schedule in pdf format. This is currently a manual process and needs some automating. Though some performance data will still need manual intervention to clean up some data.   
* Download the current schedule
* Convert PDF file to text
* Edit the text file so all the data is in one column
* Add a header record and a Day number against each date.
* Cleanse the data to make sure the titles of the performances match the ones stored in the artists table. 
* Convert text file to csv for data uploading

##### Download the current schedule from the official web site and convert the pdf file to text format.   
 
eg using pdftotext utility with -layout option   
 pdftotext bluesfest/extract/Bluesfest16SCHEDULE160302.PDF bluesfest/extract/Bluesfest16SCHEDULE160302.txt -layout  

##### Using a text editor Cut and Paste the contents of the text file into a single column of data  

Note the format of the data may change in later years.   
(This data is from 2016)   
The schedule has five columns of data, one for each day of the festival. Each column has a date, followed by stage header and then performance times for that stage, with the start time, name of artist and duration of performance.  

Example data from the beginning of the first 2 columns:

| -      |  THURSDAY 24TH                        | -      |       FRIDAY 25TH                           | 
| ---    |  -------------                        | ----   |  -----                                      |
| START  |                                       |        |                                             |
| TIME   |                MOJO                   | START  |                                             |      
|        |                                       | TIME   |               MOJO                          |
|        |                                       |        |                                             |      
| 22.45  |        KENDRICK LAMAR 75 min          |  22.30 |           THE NATIONAL 90 min               |
| 20.45  |         D'ANGELO 90 min               |  20.30 |        CITY AND COLOUR 90 min               |  
| 19.00  |     KAMASI WASHINGTON 75 min          |  18.30 |  NAHKO & MEDICINE FOR THE PEOPLE 90 min     |
| 17.30  |         HIATUS KAIYOTE 60 min         |  17.00 |          GRACE POTTER 60 min                |
| 16.00  |    FANTASTIC NEGRITO 60 min           |  15.30 |            ELLE KING 60 min                 |
| 15.50  |      WELCOME TO COUNTRY 10 min        |  14.00 |           LORD HURON 60 min                 |
|        |                                       |  12.45 |             KALEO 45 min                    |
|        |                                       |  12.00 |   ARAKWAL OPENING CEREMONY 30 min           |
                                                                                                         
                                                                                                         
* Cut each daily column and append under the previous.   
* On the same row as the day of the week and calendar number insert the day number at the beginning of the line

 eg.   
| DAY  3 | SATURDAY 26TH |                               
| ---    | --- |
 
* Insert a header row at the beginning of the file with the date the schedule was downloaded eg. `SCHEDULEDATE	20160302` where the date can be in any format as long as there are no spaces and unique to any currently in the performances table. eg The use of date is just a convience to remind the administrator which schedule is being loaded. It could include a version for example `20160302V2`.

Note: The description of the performance may not exactly match the name of an artist previously downloaded. In these cases the row of data will need to be amended by replacing the performance title with artist name and placing the performance title after the duration. Then the loading program can match the artist to the performance description.The loading rake task will reject artists not found in the artists table. In most cases they will be the same.   
eg.   
**Replace** 
| 23.00  | THE WAILERS PRESENT SURVIVAL 60 min | 
| ---    |  ---  |
**With**
| 23.00  | THE WAILERS   60 min | THE WAILERS PRESENT SURVIVAL |
| ---    |  ---  | --- |

An example from the beginning of a completed file:

| SCHEDULEDATE	| 20160304 |
| ---           | ---      |
| DAY 1       | THURSDAY 24TH |
| START |     |
| TIME  |    MOJO |
| | |                                                     
| 22.45 | KENDRICK LAMAR 75 min   |
| 20.45 | D'ANGELO 90 min         |
| 19.00 | KAMASI WASHINGTON 75 min   |
| 17.30 | HIATUS KAIYOTE 60 min      |
| 16.00 | FANTASTIC NEGRITO 60 min   |
| 15.50 | WELCOME TO COUNTRY 10 min  |
| START | |
| TIME  |            JAMBALAYA       |
| | |                                                     
| 23.00 | THE WAILERS  60 min  THE WAILERS PRESENT EXODUS  |
| 21.00 | THE WORD 90 min            |
| 19.30 | JANIVA MAGNESS 60 min      |
| 17.30 | LUKAS NELSON & PROMISE OF THE REAL 90 min   |
| 16.00 | THE BROS. LANDRETH 60 min  |
                                                     
#### Text conversion to CSV for data uploads

Note:   
The current task has the suffix date used in the input file hard coded.
* To-do 
  * Convert task to use parameter
                                                     
__Task:__		rake extract:performances   
__InputFile:__  extract/schedule160304.txt   
__OutputFile:__ db/dbloadfiles/schedule160304.csv                                                         

### Festival Data

The festival data is extracted from schedule and other items are up to the administrator.   

__File:__		dv/dbloadfiles/festivals.csv   

Header row has 8 columns: 

 | column       | description |
 | ------       | ----------- |
 | startdate    | First day of the festival formatted  yyyy-mm-dd |
 | days         | The length of the festival |		
 | scheduledate | The date of the current pdf used to update the database performances |  
 | year         | Year of the festival as it will be displayed on the screen |
 | title        | Festival title as displayed on the screen |
 | major        | Version of the current festival release  |
 | minor        | Version of the current festival release  |
 | active       | A current festival. Once new festival data is entered then this is marked as archived by setting it to false. | 

#### Configuration file for tables linked to festival

Where tables are linked to festival. The upload task looks up festival.yml to identify the correct festival record to join to based on title and startdate. This file is created manually.

* File: 	db/dbloadfiles/festival.yml   

eg

```yml
--- 
- title: Bluesfest
  startdate: 2016-03-24 
```

#### Stage Data

Note:   
 The file `stages.csv` is created manually from data found in the The Playing Schedule.   
 Each stages record is linked to a festival record.
 The code value is a unique value used to match a CSS class/id to configure the background colour when displaying a stage.
 
 eg.
 
```css
 #color-ja {
	color: white;
		background-color:#D8598F;
	}
```

__File:__		db/dbloadfiles/stages.csv   
__Delimiter:__ tab

Header row has 3 columns: 

 | column       | description |
 | ------       | ----------- |
 | title        | The description displayed on the screen |
 | code         | Used by application to identify each stage |
 | seq          | Sequence the stages will appear when listed within a web page |

eg

```csv
title	code	seq
Mojo	mo	1
Crossroads	cr	2
Delta	de	4
Jambalaya	ja	3
Juke Joint	ju	5
```

#### Artist Pages Data

Note:   
  The file `artistpages.csv` is created manually from the alphabetical list of artists. The administrator sets the range of artists so there are approximately a dozen artists listed per page. It is the responsiblity of the administrator to set up the data correctly. Even though the range displays 'A-B' the range is actually set to pick up and include artist titles that start with a number. 
  
__File:__		artistpages.csv   
__Delimiter:__ comma

Header row has 4 columns: 

 | column       | description |
 | ------       | ----------- |
 | letterstart  | The letter to begin the range of artist titles to be selected and shown for a page |
 | letterend    | The letter to end the range |
 | title        | The description to be displayed for this range |
 | seq          | Sequence the letter range is to be displayed |
 
 eg.    
 
 ```
 letterstart,letterend,title,seq
"0","b","A-B",1
"c","e","C-E",2 
"f","i","F-I",3
"j","l","J-L",4
"m","p","M-P",5
"r","s","R-S",6
"t","tm","T-Tm",7  			
"tn","z","Tn-Z",8			
```
  
### Data Loading

The data files to used to populate the database are located in db/dbloadfiles.   
The tasks to upload the data are located in lib/tasks/uploads.rake.     
The services run by the tasks are located in app/services.   

#### Table:	__festivals__
Note:   
It is assumed there will be only one festival record per year. So the loader performs a look up based on year and will overwrite the contents of a festival record when it already exists.   

__Task:__		rake uploads:festival   
__File:__		db/dbloadfiles/festivals.csv   

#### Table:	__artists__
Note:   
  When creating an artist record the name is converted into an artist identifier by removing spaces, punctuation and making lower case. This is used by the performances table uploader to match performance to an artist.   
  
__Task:__		rake uploads:artists   
__File:__		artists.csv   
  
* To-do:
  * Task to tidy table by removing non active artists

#### Table:	stages

__Task:__		rake uploads:stages   
__File:__		stages.csv   

#### Table:	performances
Note:   
The suffix is currently hardcoded into task.
When the upload task is run against a new file with a different schedule version date, the performance records which have the same artist,stage,starttime are updated with new starttime, performance title and duration. Otherwise a new record is created for each performance entry. At the end of uploading any artist records in artists table for the same festival record who do not have at least one performance record, are marked as inactive. Any performance records for the festival with a different schedule version are removed.

__Task:__		rake uploads:performances   
__File:__		schedule**yymmdd**.csv where the date of the schedue is used as a suffix in the format yymmdd.   

* To-do
  * Convert hardcoded date to a parameter.   




#### Table: artistpages

__Task:__		rake uploads:artistpages   
__File:__		artistpages.csv   