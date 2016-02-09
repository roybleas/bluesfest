# == Schema Information
#
# Table name: festivals
#
#  id           :integer          not null, primary key
#  startdate    :date
#  days         :integer
#  scheduledate :date
#  year         :string
#  title        :string
#  major        :integer
#  minor        :integer
#  active       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe FestivalsController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
	it "renders the :index template" do
		get :index
		expect(response).to render_template :index
	end
end
