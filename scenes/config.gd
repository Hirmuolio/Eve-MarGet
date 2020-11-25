extends Node

const config_path : String = "user://settings.cfg"
var config := ConfigFile.new()

# Market
var region_id := 10000002 # Jita

# Search
#var flatten_groups := true
var search_display_mode = 0 # 0 = ungrouped, 1=top grouped, 2=grouoped
var min_search_length = 3
var search_mode = 0 # 0 = findn(), 1 = matchn() exact match, 2 = is_subsequence_ofi()


func _ready():
	var err = config.load( config_path )
	if err == OK:
		load_config()
	else:
		print( "No config file found. Using defaults.")
		save_config()


func load_config():
	search_display_mode = config.get_value("search", "search_display_mode", 0)
	min_search_length = config.get_value("search", "min_search_length", 3)
	search_mode = config.get_value("search", "search_mode", 2)

func save_config():
	config.set_value("search", "search_display_mode", search_display_mode)
	config.set_value("search", "min_search_length", min_search_length)
	config.set_value("search", "search_mode", search_mode)
	config.save( config_path )
