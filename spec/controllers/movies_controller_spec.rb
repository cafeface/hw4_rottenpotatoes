require 'spec_helper'

describe MoviesController do
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
    end
    describe 'after vaild search' do
      before :each do
        movie = FactoryGirl.build(:movie, :id => '1', :title => 'Milk', :rating => 'R', :director => 'Unknown')
        Movie.stub(:find).with('1').and_return(movie)
        movie.stub(:moviesWithSameDirector).and_return(@fake_results)
        get :similar, {:id => '1'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('similar')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end
    describe 'after search fails' do
      before :each do
        movie = FactoryGirl.build(:movie, :id => '1', :title => 'Milk', :rating => 'R')
        Movie.should_receive(:find).with('1').and_return(movie)
        movie.should_receive(:moviesWithSameDirector).and_return(nil)
        get :similar, {:id => '1'}
      end
      it 'should redirect to /' do
        response.should redirect_to('/')
      end
    end
  end
end
