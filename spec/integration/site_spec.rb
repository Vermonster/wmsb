require 'spec_helper'

feature 'Home page', js: true do
  scenario 'visit home page' do
    visit '/'
    page.should have_content "Where's My School Bus"
  end
end
