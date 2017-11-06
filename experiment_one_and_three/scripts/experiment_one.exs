Code.load_file("gather_brewerydb_data.exs", "scripts")
HTTPoison.start

#########################################################################################
# For demonstration puposes, here are examples of API calls that we'll need to do
# our application.
#########################################################################################

# print all the categories
IO.puts("\n\nAll categories...")
BeerData.get_resource_all_pages("categories")
|> BeerData.print_by_name_and_id

# get all styles - this one will be paginated
IO.puts("\n\nAll styles...")
BeerData.get_resource_all_pages("styles")
|> BeerData.print_by_name_and_id


# get a style by categoryId
# The API does not accept filtering styes by categoryId, so we'll have to do it manually
# on our end
get_cat_id = 11

IO.puts("\n\nStyles with category ID #{get_cat_id}...")
BeerData.get_resource_all_pages("styles")
|> Enum.filter(fn(style) -> 
	Map.get(style, "categoryId") == get_cat_id end) 
|> BeerData.print_by_name_and_id

# get all beers within a style
# This is an operation we'll need to do frequently in our app
IO.puts("\n\nBeers with styleId 19...")
BeerData.get_resource_all_pages("beers", "styleId", 19)
|> (fn(all) -> 
	IO.puts("----->Beers in this style: #{length all}"); all end).()
|> BeerData.print_by_name_and_id

# get a category by id
IO.puts("\n\nGet category by id...")
BeerData.get_by_id("category", 5)
|> BeerData.print_by_name_and_id

# # get a style by ID
IO.puts("\n\nGet style by id...")
BeerData.get_by_id("style", 3)
|> BeerData.print_by_name_and_id

# # iterate through the styles, printing all of the beers within each style
# # NOTE: this is a LOT of beers...

# IO.puts("\n\nAll styles...")
# styles = BeerData.get_resource("styles")
# elem(styles, 0)
# |> Enum.map( 
# 	fn(s) -> 
# 		s
# 		|> BeerData.get_beers_with_style
# 		|> (fn(all) 
# 			-> IO.puts("Beers in this style:#{length all}"); all end).()
# 		|> BeerData.print_by_name_and_id
# 	end
# )

# # get all the breweries within each state
# # NOTE: this takes FOREVER essentialy

# BeerData.states()
# |> Enum.map(
# 	fn(s) ->
# 		s
# 		|> BeerData.get_breweries_in_state
# 		|> (fn(all) 
# 			-> IO.puts("Breweries in this state:#{length all}"); all end).()
# 		|> BeerData.print_breweries
# 	end
# )