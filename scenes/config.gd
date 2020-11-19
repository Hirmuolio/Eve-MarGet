extends Node


# Market
var region_id := 10000002 # Jita

# Search
#var flatten_groups := true
var search_display_mode = 0 # 0 = ungrouped, 1=top grouped, 3=grouoped
var min_search_length = 3
var search_mode = 0 # 0 = findn(), 1 = matchn() exact match, 2 = is_subsequence_ofi()


func _ready():
	pass
