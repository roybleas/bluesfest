require 'rails_helper'

class FakesController < ApplicationController
  include Validations
end
 
describe FakesController do
	context "valid_dayindex" do
		 it 'retuns zero if festival is nil ' do	
		 	dayindex = 1
		 	festival = nil
			expect(subject.valid_dayindex(festival,dayindex)).to eq 0
		end
		
		context "when festival record exists" do
		  before(:each) do
		  	@festival = create(:festival)
		  end
		  
		  it 'has the first valid day index ' do	
		  	dayindex = 1
				expect(subject.valid_dayindex(@festival,dayindex)).to eq 1
			end
			it 'has the last valid day index ' do
			 	dayindex = 5
				expect(subject.valid_dayindex(@festival,dayindex)).to eq 5
			end
			it 'resets index to first if less than minimum' do
				dayindex = 0
				expect(subject.valid_dayindex(@festival,dayindex)).to eq 1
			end
			it 'resets index to last if greate than maximum' do
				dayindex = 6
				expect(subject.valid_dayindex(@festival,dayindex)).to eq 5
			end
		
			it 'resets index to first if not integer' do
				dayindex = 'two'
				expect(subject.valid_dayindex(@festival,dayindex)).to eq 1
			end
		end
	end
	
	context "valid dayofweek" do
		it 'retuns nil if festival is nil ' do	
		 	dayindex = 1
		 	festival = nil
			expect(subject.valid_dayofweek(festival,dayindex)).to be_nil
		end

		describe 'actual date of day index' do			
			before(:each) do
				@festival = create(:festival,days: 3, startdate: '2016-03-1')
			end				
			it 'returns date of first day of festival' do
				dayindex = 1
				expect(subject.valid_dayofweek(@festival,dayindex)).to eq Date.parse('2016-03-01').strftime("%a")
			end
			it 'returns date of third day of festival' do
				dayindex = 3
				expect(subject.valid_dayofweek(@festival,dayindex)).to eq Date.parse('2016-03-03').strftime("%a")
			end
			it 'returns date of last day of festival when invalid day index' do
				dayindex = 32
				expect(subject.valid_dayofweek(@festival,dayindex)).to eq Date.parse('2016-04-01').strftime("%a")
			end
		end
	end
	context "previous dayindex" do
		before(:each) do
			@festival = create(:festival,days: 3)
		end				

		it 'returns nil if festival is nil ' do	
			dayindex = 1
			festival = nil
			expect(subject.previous_dayindex(festival,dayindex)).to be_nil
		end
			
		it 'returns previous day index when not first day' do
			dayindex = 2
			expect(subject.previous_dayindex(@festival,dayindex)).to eq 1
		end
		it 'returns last day of festival index when first day' do
			dayindex = 1
			expect(subject.previous_dayindex(@festival,dayindex)).to eq 3
		end
		it 'returns first day of festival when invalid day index' do
			dayindex = 32
			expect(subject.previous_dayindex(@festival,dayindex)).to eq 1
		end
		it 'returns first day of festival when not integer' do
			dayindex = "a"
			expect(subject.previous_dayindex(@festival,dayindex)).to eq 1
		end

	end
	context "next dayindex" do
		before(:each) do
			@festival = create(:festival,days: 3)
		end				

		it 'returns nil if festival is nil ' do	
			dayindex = 1
			festival = nil
			expect(subject.next_dayindex(festival,dayindex)).to be_nil
		end
			
		it 'returns next day index when not last day' do
			dayindex = 2
			expect(subject.next_dayindex(@festival,dayindex)).to eq 3
		end
		it 'returns first day of festival index when last day' do
			dayindex = 3
			expect(subject.next_dayindex(@festival,dayindex)).to eq 1
		end
		it 'returns last day of festival when invalid day index' do
			dayindex = 32
			expect(subject.next_dayindex(@festival,dayindex)).to eq 3
		end
		it 'returns last day of festival when not integer' do
			dayindex = "a"
			expect(subject.next_dayindex(@festival,dayindex)).to eq 3
		end

	end
	
	context "previous stage" do
		before(:each) do
			festival = create(:festival_with_stages_random_order)
			@stages = Stage.order(seq: :asc).all
		end

		it 'returns nil if stages is nil ' do	
			stage = nil
			stages = nil
			expect(subject.previous_stage(stages,stage)).to be_nil
		end
			
		it 'returns previous stage when not first stage' do
			stage = @stages[1]
			expect(subject.previous_stage(@stages,stage)).to eq @stages[0]
		end
		it 'returns previous stage when last stage' do
			stage = @stages[4]
			expect(subject.previous_stage(@stages,stage)).to eq @stages[3]
		end
		it 'returns last stage when first stage' do
			stage = @stages[0]
			expect(subject.previous_stage(@stages,stage)).to eq @stages[4]
		end	
	end
	context "next stage " do
		before(:each) do
			festival = create(:festival_with_stages_random_order)
			@stages = Stage.order(seq: :asc).all
		end

		it 'returns nil if stages is nil ' do	
			stage = nil
			stages = nil
			expect(subject.next_stage(stages,stage)).to be_nil
		end
			
		it 'returns next stage when not last stage' do
			stage = @stages[1]
			expect(subject.next_stage(@stages,stage)).to eq @stages[2]
		end
		it 'returns next stage when first stage' do
			stage = @stages[0]
			expect(subject.next_stage(@stages,stage)).to eq @stages[1]
		end
		it 'returns first stage when last stage' do
			stage = @stages[4]
			expect(subject.next_stage(@stages,stage)).to eq @stages[0]
		end	
	end
end