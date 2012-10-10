require 'spec_helper'

feature 'Home page', js: true do
  scenario 'visit home page' do
    visit '/'
    page.should have_content "Where's My School Bus"
    page.should have_css 'a:contains(Alice)'
  end

  scenario 'view bus map and go back' do
    visit '/'
    click_link 'Alice'

    page.should have_css 'div.map'

    within 'div.map' do
      page.should have_content '1'
      page.should have_no_content '2'
    end

    click_link 'Back'

    page.should have_no_css 'div.map'

    click_link 'Bob'

    page.should have_css 'div.map'

    within 'div.map' do
      page.should have_content '2'
      page.should have_no_content '1'
    end
  end
end
