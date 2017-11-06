defmodule BeerData do
	
	defp base_path() do
		"http://api.brewerydb.com/v2"
	end

	defp api_key() do
		Application.get_env(:beer_project_experiment1, :api_key)
	end

	def states() do
		Application.get_env(:beer_project_experiment1, :states)
	end

	def path(resource, key, value) do
		"#{base_path()}/#{resource}/#{api_key()}&#{key}=#{to_string((value))}"
	end

	def path(resource) do
		"#{base_path()}/#{resource}/#{api_key()}"
	end

	@doc """
	Do a GET request to the specified BreweryDB resource (eg. "beer", "brewery", "breweries", etc)
	"""
	@spec get_resource(String) :: {Map, Integer}
	def get_resource(brewery_db_resource) do
		path(brewery_db_resource)
		|> get_path
	end

	@doc """
	Same as above, but get every page of associated content
	"""
	@spec get_resource(String, String, String) :: {Map, Integer}
	def get_resource_all_pages(brewery_db_resource) do
		api_path = path(brewery_db_resource)
		api_path
		|> get_path
		|> maybe_get_all_pages(api_path)
	end

	@doc """
	Do a GET request to the specified path, adding the key/value pair after the
	api_key() with &key=value
	"""
	@spec get_resource(String, String, String) :: {Map, Integer}
	def get_resource(brewery_db_resource, key, value) do
		path(brewery_db_resource, key, value)
		|> get_path
	end

	@doc """
	Same as above, but get every page of associated content
	"""
	@spec get_resource(String, String, String) :: {Map, Integer}
	def get_resource_all_pages(brewery_db_resource, key, value) do
		api_path = path(brewery_db_resource, key, value)
		api_path
		|> get_path
		|> maybe_get_all_pages(api_path)
	end

	@doc """
	Using the passed-in string as the full path, perform a GET request and return
	the result as a tuple with the following form

	"""
	@spec get_path(String) :: {Map, Integer}
	def get_path(full_path) do
		full_path
		|> HTTPoison.get!
		# result of Poison.decode/1 is (ex:) {:ok, %{"data": [], "numberOfPages": X}}
		|> (fn(resp) -> Poison.decode(resp.body) end).()
		|> elem(1)
		|> 
		(fn(j) -> 
			{ Map.get(j, "data"), Map.get(j, "numberOfPages", 1) }
		end).()
	end


	@doc """
	Add a key value pair to the end of the path.
	"""
	def add_attr_to_path(path, key, value) do
		"#{path}&#{key}=#{to_string(value)}"
	end

	@doc """
	Get a path by id, return as a list.
	"""
	def get_by_id(path, id) do
		resp = HTTPoison.get! "#{base_path()}/#{path}/#{id}/#{api_key()}"
		Poison.decode(resp.body)
		|> elem(1)
		|> Map.get("data")
		|> List.wrap
	end

	@doc """
	Take in a list of objects from BreweryDB that contain a "name" and "id" tag,
	and print out those fields.
	"""
	def print_by_name_and_id(objects_list) do
		Enum.map(objects_list, fn(c) -> 
			IO.puts(Map.get(c, "name") 
			<> ", ID: " <> to_string(Map.get(c, "id")))
		end)
	end

	# Base case for get_all_pages_helper
	defp get_all_pages_helper(acc, path, 1) do
		new_data = 
		add_attr_to_path(path, "p", 1)
		|> get_path
		|> elem(0)
		acc ++ new_data
	end

	# Get all pages for a specific resource, using an accumulator to return a single list of
	# objects found in pages [@page_num, 1]
	defp get_all_pages_helper(acc, path, page_num) do
		new_data = 
		add_attr_to_path(path, "p", page_num)
		|> get_path
		|> elem(0)
		acc = acc ++ new_data
		get_all_pages_helper(acc, path, page_num - 1)
	end

	# Get all pages and wrap into a single list.
	defp get_all_pages(path, num_pages) do
		get_all_pages_helper([], path, num_pages)
	end

	# Consume the result of get_resource or get_path, and get all the pages assocaited
	# with that result, or just return the result if there's only one page.
	# Use the "api_path" to complete subsequent requests, if necessary.
	defp maybe_get_all_pages(req_result, api_path) do
		case num_pages = elem(req_result, 1) do
			1 -> elem(req_result, 0)
			_ -> get_all_pages(api_path, num_pages)
		end
	end

	@doc """
    Get all beers with given style
	"""
	def get_beers_with_style(%{"name" => name, "id" => id}) do
		IO.puts("\n\nbeers with style #{name}:")
		get_resource("beers", "styleId", id)
		|> maybe_get_all_pages( path("beers", "styleId", id) )
	end

	@doc """
    Get all beers with given style
	"""
	def get_beers_with_style_id(id) do
		IO.puts("\n\nbeers with styleId #{id}:")
		get_resource("beers", "styleId", id)
		|> maybe_get_all_pages( path("beers", "styleId", id) )
	end

	def print_brewery_page(brewery_list, page_num) do
		IO.puts("\n\nPrinting brewery page #{page_num}:")
		print_by_name_and_id(brewery_list)
	end

	@doc """
	Get all breweries within a given state. For some reason, only querying by state returns
	a bunch of offshoots from actual breweries, all names "Main Brewery". We are only interested
	in main locations (eg. we care about "Trillium", but dont care about 12 other "Main Brewery"
	locations that are owned by Trillum)
	"""
	def get_breweries_in_state(state) do
		api_path = path("locations", "region", state)
		get_path(api_path)
		|> maybe_get_all_pages(api_path)
	end

	@doc """
	Consumes a list of locations obtained from the "locations" resource, and print out
	their name as well as the name of the brewery that owns them.
	"""
	def print_breweries(locations_list) do
		Enum.map(locations_list, fn(c) -> 
			IO.puts(Map.get(c, "name") 
			<> ", Brewery Name:\n-----------> " 
			<> to_string(c |> Map.get("brewery") |> Map.get("name")))
		end)
	end

end
