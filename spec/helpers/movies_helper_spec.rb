require 'spec_helper'

describe MoviesHelper do
  it 'should correctly calculate oddness' do
    oddness(1).should == 'odd'
    oddness(2).should == 'even'
  end
end

