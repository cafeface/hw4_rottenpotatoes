require 'spec_helper'

describe MoviesController do
  before :each do
    post :create, {:title => 'Alien', :rating => 'R',
      :director => 'Ridley Scott'}
    post :create, {:title => 'Gladiator', :rating => 'R',
      :director => 'Ridley Scott'}
    post :create, {:title => 'Hannibal', :rating => 'R',
      :director => 'Ridley Scott'}
  end
  describe 'selecting by rating' do
    before :each do
      @ratings = Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
    end
    it 'should select only those movies with my chosen ratings' do
      get :index, {:sort => 'title', :ratings => @ratings}
      @ratings['G'] = '0'
      get :index, {:sort => 'title', :ratings => @ratings}
      response.should redirect_to(:controller => 'movies',
        :action => 'index', :sort => 'title', :ratings => @ratings)
    end
  end
  describe 'sorting by selected header' do
    before :each do
      @ratings = Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
    end
    it 'should sort by title when I click on title header' do
      get :index, {:sort => 'title', :ratings => @ratings}
      response.should redirect_to(:controller => 'movies',
        :action => 'index', :sort => 'title', :ratings => @ratings)
    end
    it 'should sort by release date when I click on release date header' do
      get :index, {:sort => 'release_date', :ratings => @ratings}
      response.should redirect_to(:controller => 'movies',
        :action => 'index', :sort => 'release_date', :ratings => @ratings)
    end
  end
  describe 'updating movie data' do
    it 'should update a movie with id 1' do
      get :update, {:id => 1}
      response.should redirect_to('/movies/1')
    end
  end
  describe 'finding movies in the database' do
    before :each do 
      get :index
    end
    it 'should select the Index template for rendering' do
      response.should render_template('index')
    end
  end
  describe 'creating a new movie' do
    before :each do
    end
    it 'should select the New movie template for rendering' do
      get :new
      response.should render_template('new')
    end
    it 'should then show the page for the new movie' do
      post :create, {:title => 'Milk', :rating => 'R'}
      response.should redirect_to(movies_path)
    end
  end
  describe 'editing a movie' do
    it 'should edit a movie with id 1' do
      get :edit, {:id => 1}
      response.should render_template('edit')
    end
  end
  describe 'showing movie details' do
    before :each do
      post :create, {:title => 'Alien', :rating => 'R',
        :director => 'Ridley Scott'}
    end
    it 'should show a movie with id 1' do
      get :show, {:id => 1}
      response.should render_template('show')
    end
  end
  describe 'finding movies with the same director' do
    before :each do
      @fake_results = [mock('movie 1'), mock('movie 2')]
    end
    it 'should call the model method that finds movies by the director of this movie' do
      movie = FactoryGirl.build(:movie, :id => '1', :title => 'Milk', :rating => 'R')
      Movie.should_receive(:find).with('1').
        and_return(movie)
      movie.should_receive(:moviesWithSameDirector).
        and_return(@fake_results)
      get :similar, {:id => '1'}
      response.should render_template('similar')
      assigns(:movies).should == @fake_results
    end
    describe 'after vaild search' do
      it 'should really find matches' do
        movie = FactoryGirl.build(:movie, :id => '1', :title => 'Prometheus', 
          :rating => 'R', :director => 'Ridley Scott')
        Movie.stub(:find).with('1').and_return(movie)
        get :similar, {:id => '1'}
        response.should render_template('similar')
      end
    end
    describe 'after search fails' do
      before :each do
        movie = FactoryGirl.build(:movie, :id => '1', :title => 'Milk', :rating => 'R')
        Movie.should_receive(:find).with('1').and_return(movie)
        get :similar, {:id => '1'}
      end
      it 'should redirect to /' do
        response.should redirect_to('/')
      end
      it 'should then render the fail template' do
        get :fail
        response.should render_template('fail')
      end
    end
  end
  describe 'delete movie' do
    it 'should delete a movie with id 1 and redirect to movies_path' do
      delete :destroy, {:id => 1}
      response.should redirect_to movies_path
    end
  end
end
