class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @all_ratings = Hash.new
    Movie.ratings.each do |rating|
      @all_ratings[rating] = true
    end
    #ratings selected
    if params[:ratings]
        @all_ratings.each_key do |rating|
        @all_ratings[rating] = false unless params[:ratings].key?(rating)
      end
      @checked_ratings = params[:ratings].keys
      session[:ratings]=params[:ratings]
    #checkboxes checkboxed
    elsif session[:ratings]
     redirect_to movies_path(:sort=>params[:sort], :ratings=>session[:ratings]) and return
    else
      @checked_ratings = @all_ratings.keys
    end

    #movie rendering in specified order
    if params[:sort]
      @sorting = session[:sort] = params[:sort]
      if params[:sort] == "title"
        @title_tab = "hilite"
      elsif params[:sort] == "release_date"
        @release_date_tab = "hilite"
      end
    elsif session[:sort]
      redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings], ) and return
    end
    @movies = Movie.find(:all, :conditions => {:rating => @checked_ratings}, :order => @sorting)
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
