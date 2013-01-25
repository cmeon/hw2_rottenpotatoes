class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
      #movie ratings categories
    @all_ratings = Movie.ratings
    
      #ratings for checkbox
    if params[:ratings]
       @checked_ratings = params[:ratings].keys
    end
    
    if @sort_order = params[:sort]
      #CSS highlighting changes
      if @sort_order == "title"
        @title_tab = "hilite"
      elsif @sort_order == "release_date"
        @release_date_tab = "hilite"
      end
      #movie rendering in specified order
      @movies = Movie.find(:all, :order => "#{@sort_order}") # #{['ASC', 'DESC'][@order]}")
    else
      @movies = Movie.all
    end
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
