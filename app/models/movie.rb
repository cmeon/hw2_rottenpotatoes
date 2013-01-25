class Movie < ActiveRecord::Base
  def self.ratings
    @all_ratings = []
    self.find(:all).each do |movie|
      @all_ratings << movie.rating
    end
    @all_ratings.uniq!
  end
end
