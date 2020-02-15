class Movie < ActiveRecord::Base
    
    def self.all_ratings
        Movie.select('rating').uniq.collect{|movie| movie.rating}
    end
    
    def self.with_ratings(ratings)
        Movie.where(:rating => ratings.keys)
    end
end
