# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :beer_project_experiment1, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:beer_project_experiment1, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"


config :beer_project_experiment1,
	accepted_styles: [
		"Classic English-Style Pale Ale",
		"English-Style India Pale Ale",
		"English-Style Summer Ale",
		"English-Style Pale Mild Ale",
		"English-Style Dark Mild Ale",
		"English-Style Brown Ale",
		"Oatmeal Stout",
		"American-Style India Pale Ale",
		"American-Style Amber/Red Ale",
		"Golden or Blonde Ale",
		"American-Style Sour Ale",
		"American-Style Stout",
		"South German-Style Hefeweizen / Hefeweissbier",
		"Belgian-Style Dubbel",
		"Belgian-Style Tripel",
		"Belgian-Style Quadrupel",
		"Belgian-Style Blonde Ale",
		"Belgian-Style White (or Wit) / Belgian-Style Wheat",
		"French & Belgian-Style Saison",
		"German-Style Pilsener",
		"Australian-Style Pale Ale",
		"American-Style Lager",
		"Specialty Beer",
		"New England Cider",
		"Session India Pale Ale",
		"Wood- and Barrel-Aged Pale to Amber Beer",
		"Wood- and Barrel-Aged Sour Beer",
		"Session Beer",
	],

	states: [
		'Alabama',
		'Alaska',
		'Arizona',
		'Arkansas',
		'California',
		'Colorado',
		'Connecticut',
		'Delaware',
		'Florida',
		'Georgia',
		'Hawaii',
		'Idaho', 
		'Illinois',
		'Indiana',
		'Iowa',
		'Kansas',
		'Kentucky',
		'Louisiana',
		'Maine',
		'Maryland',
		'Massachusetts',
		'Michigan',
		'Minnesota',
		'Mississippi',
		'Missouri',
		'Montana',
		'Nebraska',
		'Nevada',
		'New%20Hampshire',
		'New%20Jersey',
		'New%20Mexico',
		'New%20York',
		'North%20Carolina',
		'North%20Dakota',
		'Ohio',
		'Oklahoma',
		'Oregon',
		'Pennsylvania',
		'Rhode%20Island',
		'South%20Carolina',
		'South%20Dakota',
		'Tennessee',
		'Texas',
		'Utah',
		'Vermont',
		'Virginia',
		'Washington',
		'West%20Virginia',
		'Wisconsin',
		'Wyoming'
	]

import_config "secret.exs"
