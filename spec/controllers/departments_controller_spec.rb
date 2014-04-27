require 'spec_helper'

describe DepartmentsController do
  before do
    @department = create :department
    @admin_user = create :user_admin
  end

  describe "deleting via ajax" do

    context "when logged in" do
      before { log_in_user @admin_user, no_capybara: true }

      it "reduces the department count by 1" do
       expect do
         xhr :delete, :destroy, id: @department.id
       end.to change(Department, :count).by(-1)
      end

      it "returns success" do
        xhr :delete, :destroy, id: @department.id
        expect(response).to be_success
      end

      it "deletes the correct department" do
        xhr :delete, :destroy, id: @department.id
        expect { @department.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when not logged in" do

      it "does not reduce the department count" do
        expect do
          xhr :delete, :destroy, id: @department.id
        end.not_to change(Department, :count)
      end

      it "does not return success" do
        xhr :delete, :destroy, id: @department.id
        expect(response).not_to be_success
      end

      it "does not delete the department" do
        xhr :delete, :destroy, id: @department.id
        expect { @department.reload }.not_to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end