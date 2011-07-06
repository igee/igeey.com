class CasesController < ApplicationController
  respond_to :html
  
  def create
    @problem = Problem.find(params[:case][:problem_id])
    @case = Case.new(params[:case])
    @case.save
    respond_with @problem
  end
end
