class VenuesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_venue, :except => [:index,:new,:create]
  respond_to :html
  
  def new
    @venue = Venue.new(:latitude => params[:latitude],:longitude => params[:longitude])
  end
  
  def create
    @venue = Venue.new(params[:venue])
    @venue.creator = current_user
    flash[:notice] = 'Venue was successfully created.' if @venue.save
    respond_with(@venue)
  end
  
  def show
    
  end
  
  private
  def find_venue
    @venue = Venue.find(params[:id])
  end

end
