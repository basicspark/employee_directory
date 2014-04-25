require 'spec_helper'

describe "Department pages" do

  describe "index" do
    before do
      @department = create :department_with_phone
      visit departments_path
    end

    it "displays the department list table" do
      expect(page).to have_selector('table.table-striped.table-hover')
    end

    it "contains the department's name" do
      expect(page).to have_selector('td', text: @department.name)
    end

    it "contains the department's location" do
      expect(page).to have_selector('td', text: @department.location)
    end

    it "contains the department's phone number" do
      expect(page).to have_selector('td', text: @department.phone)
    end

    it "contains the department's id as the id of the row" do
      expect(page).to have_selector("tr\##{@department.id}")
    end

    describe "pagination" do
      before(:all) { 20.times { create :department } }
      after(:all) { Department.delete_all }

      it "contains the pagination selector" do
        expect(page).to have_selector('ul.pagination')
      end

      it "lists each department" do
        Department.paginate(page: 1).each do |dept|
          expect(page).to have_selector('td', text: dept.name)
        end
      end
    end
  end

  describe "maintenance" do
    before do
      create :department
      visit departments_path
    end

    context "adding" do

      context "when clicking the Create New Department link" do
        before { click_link 'Create New Department' }

        it "displays the Department Maintenance form" do
          expect(page).to have_selector('legend', text: 'Department Maintenance')
        end

        it "displays the blank Department Name field" do
          expect(page).to have_selector('input#department_name.form-control', text: nil)
        end

        it "displays the blank Location field" do
          expect(page).to have_selector('input#department_location.form-control', text: nil)
        end

        it "displays the blank Phone field" do
          expect(page).to have_selector('input#department_phone.form-control', text: nil)
        end

        context "then submitting with no populated fields" do
          before { click_button 'Create Department' }

          it "displays the error summary box" do
            expect(page).to have_selector('div.panel.panel-danger',
                                          text: 'Please correct the following:')
          end

          it "shows the name can't be blank error" do
            expect(page).to have_selector('li', text: "Name can't be blank")
          end

          it "highlights the Department Name field as being in error" do
            expect(page).to have_selector('div.form-group.has-error',
                                          text: 'Department Name')
          end
        end

        context "then submitting a valid record" do
          before do
            fill_in 'Department Name', with: 'My New Department'
            fill_in 'Location', with: 'My Location'
            fill_in 'Phone', with: '773-555-1212'
            click_button 'Create Department'
          end

          it "saves and displays the new department name" do
            expect(page).to have_selector('td', text: 'My New Department')
          end

          it "saves and displays the new department location" do
            expect(page).to have_selector('td', text: 'My Location')
          end

          it "saves and displays the new department phone number" do
            expect(page).to have_selector('td', text: '773-555-1212')
          end

          it "shows the department list" do
            expect(page).to have_selector('h3.panel-title',
                                          text: 'Department Maintenance')
          end

          it "displays a success message" do
            expect(page).to have_selector('div.alert.alert-dismissable.alert-success',
                                          text: 'Department was successfully created.')
          end
        end
      end
    end

    context "deleting" do

      it "deletes the department" do
        expect do
          click_link('Delete')
        end.to change(Department, :count).by(-1)
      end
    end

  end

end
