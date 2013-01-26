class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
      #movie ratings categories
    @all_ratings = Hash.new
    Movie.ratings.each do |rating|
      @all_ratings[rating] = true
    end
    
    #ratings for checkbox
    if params[:ratings]
      @all_ratings.each do |rating, check|
          @all_ratings[rating] = false unless params[:ratings].key?(rating)
      end
      session[:all_ratings] = @all_ratings
      session[:ratings] = params[:ratings].keys
      redirect_to movies_path
    end
    
    #checkboxes checkboxed
    if session[:ratings]
      @checked_ratings = session[:ratings]
    else
      @checked_ratings = @all_ratings.keys
    end
    
    #CSS highlighting changes
    if session[:sorting_order] == "title"
      @title_tab = "hilite"
    elsif  session[:sorting_order] == "release_date"
      @release_date_tab = "hilite"
    end
    
    #movie rendering in specified order
    if params[:sort]
      session[:sorting_order] = params[:sort]
      redirect_to movies_path
    end
    
    @all_ratings = session[:all_ratings]
    @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings}, :order => "#{session[:sorting_order]}")
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
