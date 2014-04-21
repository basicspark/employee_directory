require 'spec_helper'

feature "Root page" do
  feature "dynamic company and application names" do
    given(:company_name) { Rails.configuration.company_name }
    given(:application_name) { Rails.configuration.application_name }

    scenario "showing the company name in the navigation bar" do
      visit root_url
      expect(page).to have_selector('div.navbar.navbar-default')
      expect(page).to have_selector('a.navbar-brand', text: company_name)
    end

    scenario "showing the application name in the page header" do
      visit root_url
      within('div.page-header') { expect(page).to have_selector('h1',
                                  text: application_name) }
    end

    scenario "showing the application name in the page title" do
      visit root_url
      expect(page).to have_title(application_name)
    end
  end
end
