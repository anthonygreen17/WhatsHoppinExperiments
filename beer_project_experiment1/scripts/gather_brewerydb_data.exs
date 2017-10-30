defmodule BeerData do
	
	def base_path() do
		"http://api.brewerydb.com/v2"
	end

	def api_key() do
		"?key=b8858d9cead79d462f430e9726080163"
	end

	@doc """
	Do a GET request to the specified path, and return the JSON response.
	"""
	def get_path(path) do
		resp = HTTPoison.get!(
			"#{base_path()}/#{path}/#{api_key()}")
		Poison.decode(resp.body)
		|> elem(1)
		|> Map.get("data")
	end

	@doc """
	Do a GET request to the specified path, adding the key/value pair after the
	api_key() with &key=value
	"""
	def get_path(path, key, value) do
		resp = HTTPoison.get!(
			"#{base_path()}/#{path}/#{api_key()}&#{key}=#{to_string((value))}"
		)
		Poison.decode(resp.body)
		|> elem(1)
		|> Map.get("data")
	end

	@doc """
	Get a path by id, return as a list
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

	@doc """
    Get all beers with given style
	"""
	def get_beers_with_style(%{"name" => name, "id" => id}) do
		IO.puts("\n\nbeers with style #{name}:")
		get_path("beers", "styleId", id)
	end


end

HTTPoison.start

# first, print all the categories
IO.puts("\n\nAll categories...")
BeerData.get_path("categories")
|> BeerData.print_by_name_and_id


# get a category by id
IO.puts("\n\nGet category by id...")
BeerData.get_by_id("category", 5)
|> BeerData.print_by_name_and_id


# print all the styles
IO.puts("\n\nAll styles...")
styles = BeerData.get_path("styles")
BeerData.print_by_name_and_id(styles)

# get a style by ID
IO.puts("\n\nGet style by id...")
BeerData.get_by_id("style", 3)
|> BeerData.print_by_name_and_id

# iterate through the styles, printing all of the beers within each style
Enum.map(styles, 
	fn(s) -> 
		s
		|> BeerData.get_beers_with_style
		|> BeerData.print_by_name_and_id
	end
)

