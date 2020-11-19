extends Node

class_name tree_item
func get_class(): return "tree_item"

# Properties of this item
var item_name : String
var item_id : String
var is_hidden : bool = false
const is_group : bool = false


func _ready():
	pass


func create_item( new_item_id:String):
	item_id = new_item_id
	item_name = DataHandler.ids_names[item_id]
	set_name(item_name)

func filter( search_term : String ):
	
	if search_term.length() < Config.min_search_length:
		is_hidden = false
	elif Config.search_mode == 0 and item_name.findn(search_term) > -1:
		is_hidden = false
	elif Config.search_mode == 1 and item_name.matchn(search_term):
		is_hidden = false
	elif Config.search_mode == 2 and search_term.is_subsequence_ofi(item_name):
		is_hidden = false
	elif Config.search_mode > 2:
		print( "Invalid search methord")
	else:
		is_hidden = true
