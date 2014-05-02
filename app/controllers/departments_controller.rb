class DepartmentsController < ApplicationController
  include ActionRestrictions
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_department, only: [:edit, :update, :destroy]
  before_action :check_for_assigned_users, only: :destroy

  # GET /departments
  def index
    @departments = Department.paginate(page: params[:page])
  end

  # GET /departments/new
  def new
    @department = Department.new
    render :form
  end

  # GET /departments/1/edit
  def edit
    render :form
  end

  # POST /departments
  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "Department was successfully created."
      redirect_to departments_url
    else
      render :form
    end
  end

  # PATCH/PUT /departments/1
  def update
    if @department.update(department_params)
      flash[:success] = 'Department was successfully updated.'
      redirect_to departments_url
    else
      render :form
    end
  end

  # DELETE /departments/1
  def destroy
    @department.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to departments_url }
    end
  end

  private

    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :location, :phone)
    end

    # Don't allow deletion of departments with assigned users
    def check_for_assigned_users
      if @department.users.any?
        flash[:error] = "Can't delete department with assigned users."
        flash.keep(:error)
        render js: "window.location = '#{departments_url}'"
        return false
      end
    end
end
