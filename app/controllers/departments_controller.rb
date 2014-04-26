class DepartmentsController < ApplicationController
  before_action :logged_in_user
  before_action :set_department, only: [:edit, :update, :destroy]

  # GET /departments
  def index
    @departments = Department.paginate(page: params[:page])
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        flash[:success] = "Department was successfully created."
        format.html { redirect_to departments_path }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /departments/1
  def update
    respond_to do |format|
      if @department.update(department_params)
        flash[:success] = 'Department was successfully updated.'
        format.html { redirect_to departments_path }
      else
        format.html { render :edit }
      end
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

    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :location, :phone)
    end

    # All actions require a logged in user
    def logged_in_user
      redirect_to login_url, notice: 'Please log in.' unless logged_in?
    end
end
