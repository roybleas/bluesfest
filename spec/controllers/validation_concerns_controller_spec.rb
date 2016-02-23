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
				expect(subject.valid_dayofweek(@festival,dayindex)).to eq Date.parse('2016-03-01').strftime("%a %d %b")
			end
			it 'returns date of third day of festival' do
				dayindex = 3
				expect(subject.valid_dayofweek(@festival,dayindex)).to eq Date.parse('2016-03-03').strftime("%a %d %b")
			end
			it 'returns date of last day of festival when invalid day index' do
				dayindex = 32
				expect(subject.valid_dayofweek(@festival,dayindex)).to eq Date.parse('2016-04-01').strftime("%a %d %b")
			end
		end
	end
end