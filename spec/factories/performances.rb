# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  daynumber       :integer
#  duration        :string
#  starttime       :time
#  title           :string
#  scheduleversion :string
#  festival_id     :integer
#  artist_id       :integer
#  stage_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :performance do
    daynumber 3
    duration "60 mins"
    starttime "19:15"
    scheduleversion "20160216B"
    title "performance caption"
    festival nil
    artist nil
    stage nil
    factory :performance_with_festival, class: Performance do
      festival
      artist
      stage
    end
    factory :performance_with_just_festival, class: Performance do
      festival
    end
    factory :performance_with_artist, class: Performance do
      artist
    end
    factory :performance_with_artist_and_stage, class: Performance do
      artist
      stage
    end
    factory :peformance_first_schedulefile, class: Performance do
      starttime '22:45'
      daynumber 1
      scheduleversion 'testdata'
      duration '10 min'
      title 'KENDRICK LAMAR'
      festival
      stage
      association :artist, factory: :artist, name: "Kendrick Lamar", code: "kendricklamar"
      
    end
    factory :performance_with_festival_artist_and_stage, class: Performance do
      title "TOM JONES"
      daynumber 1
      festival
      artist
      stage
    end

  end
  factory :festival_for_performance,  class: Festival do
    startdate "2016-04-01"
    days 5
    scheduledate "2016-01-28"
    year "2016"
    title "Bluesfest"
    major 1
    minor 2
    active true
    
    factory :festival_with_stage_artist_performance do
      after(:create) do |festival, evaluator|
        stage = create(:stage, festival_id: festival.id, title: 'Mojo', code: 'mo', seq: 1)
        artist = create(:artist,festival_id: festival.id, name: 'Kendrick Lamar', code: 'kendricklamar', active: true)
        performance = create(:performance,festival_id: festival.id, daynumber: 1, title: 'KENDRICK LAMAR', artist_id: artist.id, stage_id: stage.id)
      end
    end
    
    factory :festival_with_stage_artist_multiple_performances do
      ignore do
        performance_count 3
      end
      after(:create) do |festival, evaluator|
        stage = create(:stage, festival_id: festival.id, title: 'Mojo', code: 'mo', seq: 1)
        artist = create(:artist,festival_id: festival.id, name: 'Kendrick Lamar', code: 'kendricklamar')
        (1..evaluator.performance_count).each do |index|
          performance = create(:performance,festival_id: festival.id, daynumber: index, title: "KENDRICK LAMAR #{index}", artist_id: artist.id, stage_id: stage.id)
        end

      end
    end
    factory :festival_with_stage_artist_multiple_performances_same_day do
      ignore do
        performance_count 5
        start_performance_time Time.new(2016,3,14,14,0)
        day_number 2
      end
      after(:create) do |festival, evaluator|
        stage = create(:stage, festival_id: festival.id, title: 'Mojo', code: 'mo', seq: 2)
        artist = create(:artist,festival_id: festival.id, name: 'Kendrick Lamar', code: 'kendricklamar')
        this_starttime = evaluator.start_performance_time
        (1..evaluator.performance_count).each do |index|
          performance = create(:performance,festival_id: festival.id, starttime: this_starttime.strftime("%H:%M"), daynumber: evaluator.day_number, title: "KENDRICK LAMAR #{index}", artist_id: artist.id, stage_id: stage.id)
          this_starttime = this_starttime + 20.minutes
        end
        stage2 = create(:stage, festival_id: festival.id, title: 'Delta', code: 'de', seq: 1)
        artist2 = create(:artist,festival_id: festival.id, name: 'Tom Jones', code: 'tomjones')
        this_starttime = evaluator.start_performance_time
        (1..evaluator.performance_count).each do |index|
          performance = create(:performance,festival_id: festival.id, starttime: this_starttime.strftime("%H:%M"), daynumber: evaluator.day_number, title: "Tom Jones #{index}", artist_id: artist2.id, stage_id: stage2.id)
          this_starttime = this_starttime + 30.minutes
        end
      end
    end
  end
end
