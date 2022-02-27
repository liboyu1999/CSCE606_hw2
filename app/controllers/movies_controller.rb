class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @ratings = Movie.get_ratings
    @ratings_checks = @ratings
      # Store sort key in session
      
    if params[:sort]
      session[:sort] = params[:sort]
    end
    # Sort base on title or release date
    
    if session[:sort] == 'movie_title'
      @movies = @movies.order(:title)
    else
      if session[:sort] == 'release_date'
        @movies = @movies.order(:release_date)
      end
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings].keys
    end
    
    if session.key?(:ratings)
      @ratings_checks = session[:ratings]
      @movies = @movies.where(rating: @ratings_checks)
    end
    flash.keep
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
