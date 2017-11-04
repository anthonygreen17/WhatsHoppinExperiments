defmodule BeerData do
	
	def base_path() do
		"http://api.brewerydb.com/v2"
	end

	def api_key() do
		?key=KEY
	end

	def states() do
		Application.get_env(:beer_project_experiment1, :states)
	end

	def num_brewery_pages() do
		189
	end

	def path(resource, key, value) do
		"#{base_path()}/#{resource}/#{api_key()}&#{key}=#{to_string((value))}"
	end

	def path(resource) do
		"#{base_path()}/#{resource}/#{api_key()}"
	end

	@doc """
	Do a GET request to the specified BreweryDB resource (eg. "beer", "brewery", "breweries", etc)

	Return a tuple of the following format:

		{json_result_list, number_of_pages}
	"""
	def get_resource(brewery_db_resource) do
		path(brewery_db_resource)
		|> get_path
	end

	@doc """
	Do a GET request to the specified path, adding the key/value pair after the
	api_key() with &key=value
	"""
	def get_resource(brewery_db_resource, key, value) do
		path(brewery_db_resource, key, value)
		|> get_path
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
	Add a key value piar to the end of the path.
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

	def get_all_pages_helper(acc, path, 1) do
		new_data = 
		add_attr_to_path(path, "p", 1)
		|> get_path
		|> elem(0)
		acc ++ new_data
	end

	def get_all_pages_helper(acc, path, page_num) do
		IO.puts("Getting page #{page_num}")
		new_data = 
		add_attr_to_path(path, "p", page_num)
		|> get_path
		|> elem(0)
		acc = acc ++ new_data
		get_all_pages_helper(acc, path, page_num - 1)
	end

	@doc """
	Get all pages and wrap into a single list.
	"""
	def get_all_pages(path, num_pages) do
		IO.puts("\nstarting to get all pages...")
		get_all_pages_helper([], path, num_pages)
	end

	@doc """
    Get all beers with given style
	"""
	def get_beers_with_style(%{"name" => name, "id" => id}) do
		IO.puts("\n\nbeers with style #{name}:")
		res = get_resource("beers", "styleId", id)

		case num_pages = elem(res, 1) do
			1 -> elem(res, 0)
			_ -> path("beers", "styleId", id) 
				 |> get_all_pages(num_pages)
		end
	end

	@doc """
    Get all beers with given style
	"""
	def get_beers_with_style_id(id) do
		IO.puts("\n\nbeers with styleId #{id}:")
		res = get_resource("beers", "styleId", id)

		case num_pages = elem(res, 1) do
			1 -> elem(res, 0)
			_ -> path("beers", "styleId", id) 
				 |> get_all_pages(num_pages)
		end
	end

	def print_brewery_page(brewery_list, page_num) do
		IO.puts("\n\nPrinting brewery page #{page_num}:")
		print_by_name_and_id(brewery_list)
	end

end

HTTPoison.start

# # first, print all the categories
# IO.puts("\n\nAll categories...")
# BeerData.get_resource("categories")
# |> BeerData.print_by_name_and_id


# # get a category by id
# IO.puts("\n\nGet category by id...")
# BeerData.get_by_id("category", 5)
# |> BeerData.print_by_name_and_id

# # # get a style by ID
# IO.puts("\n\nGet style by id...")
# BeerData.get_by_id("style", 3)
# |> BeerData.print_by_name_and_id

# # iterate through the styles, printing all of the beers within each style

# BeerData.get_beers_with_style_id(27)
# |> (fn(all) 
# 	-> IO.puts("Beers in this style:#{length all}"); all end).
# ()
# |> BeerData.print_by_name_and_id
IO.puts("\n\nAll styles...")
styles = BeerData.get_resource("styles")
elem(styles, 0)
|> Enum.map( 
	fn(s) -> 
		s
		|> BeerData.get_beers_with_style
		|> (fn(all) 
			-> IO.puts("Beers in this style:#{length all}"); all end).
		()
		|> BeerData.print_by_name_and_id
	end
)

# # get all the breweries. results are paginated, so get them with key &p=PAGE_NUM
# IO.puts("\n\nget all the breweries")

# for page_num <- 1..BeerData.num_brewery_pages() do
# 	BeerData.get_path("breweries", "p", page_num)
# 	|> BeerData.print_brewery_page(page_num)
# end


