class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    remember = false
    
    @sort_params = params[:sort_params]
    @ratings = params[:ratings]
    
    if @ratings and @sort_params
      @movies = Movie.with_ratings(@ratings).order(@sort_params)
    elsif @sort_params
      @movies = Movie.order(@sort_params)
    elsif @ratings
      @movies = Movie.with_ratings(@ratings)
    end
    
    if params[:sort_params].to_s == "title"
      @title_class = 'hilite'
    end
    if params[:sort_params].to_s == "release_date"
      @release_class = 'hilite'
    end
    
    if params[:sort_params]
      session[:sort_params] = params[:sort_params]
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    if(!params[:sort_params] and !params[:ratings]) and (session[:sort_params] and session[:ratings])
      remember = 1
    elsif !params[:sort_params] and session[:sort_params]
      remember = 1
    elsif !params[:ratings] and session[:ratings]
      remember = 1
    end
    
    if remember == 1
      flash.keep
      redirect_to movies_path(:sort_params => session[:sort_params], :ratings => session[:ratings])
    end
    
    
    #if @ratings and params[:commit] != "Refresh"
      #@ratings = Hash.new
      #@all_ratings.each do |rating|
        #@ratings[rating] = 1
      #end
    #elsif !@ratings
      #@ratings = Hash.new
    #end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
