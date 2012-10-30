class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def moviesWithSameDirector
    if director.nil? || director =~ /^\W*$/
      nil
    else
      Movie.where(:director => director)
    end
  end
end
