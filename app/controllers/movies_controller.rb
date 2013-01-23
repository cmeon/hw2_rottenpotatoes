class MoviesController < ApplicationController

  require 'movies_helper'
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    if @sort_order = session[:sorting]
      @order=session[:as].to_i
      @movies = Movie.find(:all, :order => "#{@sort_order} #{['ASC', 'DESC'][@order]}")
      @order = [1,0][@order]
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
  
  def sort
    #@movies = Movie.find(:all, :order => "#{params[:by]} ASC")
    #@movies = Movie.order("#{params[:by]} ASC")
    session[:sorting] = params[:by]
    session[:as] = params[:as]
    redirect_to :action => 'index'
  end
end
