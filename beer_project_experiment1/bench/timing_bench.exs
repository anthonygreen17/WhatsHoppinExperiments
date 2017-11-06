# bench/basic_bench.exs
defmodule BasicBench do

	Code.load_file("gather_brewerydb_data.exs", "scripts")
	use Benchfella


	#####################################################################################
	# These first few tests are to compare the time it takes to make HTTP requests to
	# other sites against the time it takes to hit the breweryDB API. 
	#
	# From initialinvestigation, it seems that BreweryDB API is very slow....depending 
	# on exactly how slow, we may need to rethink approaches
	#####################################################################################

	# don't process the HTTPoison response object for some of the requests.
	# so we can compare the timing with function calls to get_resource,
	# where we decode and process the result
	bench "get_single_brewerydb_page_beers_unprocessed" do
		BeerData.path("beers") |> HTTPoison.get!
		:ok
	end

	bench "get_single_brewerydb_page_beers_processed" do
		BeerData.get_resource("beers")
		:ok
	end

	bench "get_single_brewerydb_page_breweries_unprocessed" do
		BeerData.path("breweries") |> HTTPoison.get!
		:ok
	end

	bench "get_single_brewerydb_page_breweries_processed" do
		BeerData.get_resource("breweries")
		:ok
	end

	bench "get_single_brewerydb_page_styles_unprocessed" do
		BeerData.path("styles") |> HTTPoison.get!
		:ok
	end

	bench "get_single_brewerydb_page_styles_unprocessed" do
		BeerData.get_resource("styles")
		:ok
	end

	bench "make_single_http_request_redhat" do
		HTTPoison.get! "redhat.com"
		:ok
	end

	bench "make_single_http_request_github" do
		HTTPoison.get! "github.com"
		:ok
	end

	#####################################################################################
	# This is an operation that we'll do once the user is in the chatroom for a specific
	# style - random beers in that style will be displayed in a sidebar on the page.
	#####################################################################################

	defp get_random_beers_from_style(style_id) do
		BeerData.path("beers", "styleId", style_id)
		|> BeerData.add_attr_to_path("randomCount", 10)
		|> BeerData.add_attr_to_path("order", "random")
		|> BeerData.get_path
		:ok
	end

	bench "get_random_beers_from_style_17" do
		get_random_beers_from_style(17)
	end

	bench "get_random_beers_from_style_9" do
		get_random_beers_from_style(9)
	end

	bench "get_random_beers_from_style_24" do
		get_random_beers_from_style(24)
	end

	#####################################################################################
	# We'll do this once the user clicks on a category to dislpay different styles
	# within the category. There may be many styles.
	#####################################################################################

	defp get_styles_in_category(cat_id) do
		BeerData.get_resource_all_pages("styles")
		|> Enum.filter(fn(style) -> 
			Map.get(style, "categoryId") == cat_id end) 	
	end

	bench "get_styles_in_category_1" do
		get_styles_in_category(1)
	end

	bench "get_styles_in_category_11" do
		get_styles_in_category(11)
	end

	bench "get_styles_in_category_7" do
		get_styles_in_category(7)
	end


	#####################################################################################
	# We'll GET all categories only once - when the user decides to browse our application
	# by beers.
	#####################################################################################

	bench "get_all_categories" do
		BeerData.get_resource_all_pages("categories")
	end

	#####################################################################################
	# One of the most important operations we'll need to do is generate a listing of breweries
	# in a specific state. We want to know if it is realistic to use normal, blocking HTTP
	# requests to get all of the breweries within a state, showing them to the user all at
	# once. Based on these results, we may need to look into async HTTP or paginating
	# our own browsing of the breweries.
	#
	# CA is the state with the most breweries by far (~1000 on brewerydb). Because of how
	# their API is set up, this will take 20 HTTP requests. This is the worst case time for
	# getting all of the breweries within a state and will affect our design decisions going
	# forward.
	#####################################################################################

	bench "get_massacusetts_breweries_all_pages" do
		BeerData.get_breweries_in_state("Massachusetts")
		:ok
	end

	bench "get_MI_breweries_all_pages" do
		BeerData.get_breweries_in_state("Michigan")
		:ok
	end
	
	bench "get_CA_breweries_all_pages" do
		BeerData.get_breweries_in_state("California")
		:ok
	end

	# Maybe we'll want to display 100 or 150 results for the states like CA with ~1000 breweries.
	# Each page contains 50 results

	defp get_brewery_page(state, page_num) do
		BeerData.path("locations", "region", state)
		|> BeerData.add_attr_to_path("p", page_num)
		|> BeerData.get_path
	end

	bench "get_CA_breweries_single_page" do
		get_brewery_page("California", 1)
	end

	bench "get_CA_breweries_two_pages" do
		get_brewery_page("California", 2)
		get_brewery_page("California", 4)
	end

	bench "get_MI_breweries_three_pages" do
		get_brewery_page("Michigan", 2)
		get_brewery_page("Michigan", 17)
		get_brewery_page("Michigan", 14)
	end

end