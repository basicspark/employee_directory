require 'spec_helper'

feature "Root page" do
  given(:company_name) { Rails.configuration.company_name }
  given(:application_name) { Rails.configuration.application_name }


  feature "navigation bar" do
    scenario "shows the company name" do
      visit root_url
      expect(page).to have_selector('div.navbar.navbar-default')
      expect(page).to have_selector('a.navbar-brand', text: company_name)
    end
  end

  feature "page header" do
    scenario "shows the application name" do
      visit root_url
      within('div.page-header') { expect(page).to have_selector('h1',
                                  text: application_name) }
    end
  end

  feature "page title" do
    scenario "shows the application name" do
      visit root_url
      expect(page).to have_title(application_name)
    end
  end
end