# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  #fail "Unimplemented"
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

When /^(?:|I )follow "(.*)$"/ do |sort_option|
  case sort_option
  when "Movie Title"
    click_on("title_header")
  when "Release Date"
    click_on("release_date_header")  
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # fail "Unimplemented"
  if page.respond_to? :should
  expect(page.body =~/#{e1}.*#{e2}/m).to be >= 0
  else
    # I can find one piece of text matchingh following pattern with characteristrcs that e1 is before e2
    assert page.body =~ /#{e1}.*#{e2}/m
  end
end

When /^I press "(.*)" button/ do |button|
  click_button button
end

Then /I should (not )?see the following movies: (.*)$/ do |not_present, movies_list|
  movies_list.split(', ').each do |movie|
    if not_present
      page.should have_no_content(movie)
    else
      page.should have_content(movie)
    end
  end
end



# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(',').each do |rating|
    rating.strip!
    if uncheck
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end


Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  #fail "Unimplemented"
  rows = page.all('#movies tr').size - 1
  rows.should == Movie.count
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end

