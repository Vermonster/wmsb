require 'spec_helper'

feature 'Home page' do
  scenario 'visit home page' do
    visit '/'
    page.should have_content "Where's My School Bus"
  end
end
