# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)    
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert_not_nil page.body =~ /#{e1}(.*)/m
  assert_not_nil $1 =~ /#{e2}/
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/, */).each do |rating|
    step "#{uncheck}check \"ratings_#{rating}\""
  end
end

Given /I (un)?check all ratings/ do |un|
  Movie.all_ratings.each do |rating|
    step "#{un}check \"ratings_#{rating}\""
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  assert_not_nil page.body =~ /Director:\W*#{director}/m
end
