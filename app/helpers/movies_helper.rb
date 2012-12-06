module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sorted
    @movies = Movie.all.order(params[:id])
    redirect_to movies_path
  end
end
