extends Node

class_name tree_item
func get_class(): return "tree_item"

# Properties of this item
var item_name : String
var item_id : String
var is_hidden : bool = false
const is_group : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_item( new_item_id:String):
	item_id = new_item_id
	item_name = DataHandler.ids_names[item_id]
	set_name(item_name)

func filter( search_term : String ):
	
	if search_term == "":
		is_hidden = false
	elif item_name.findn(search_term) > -1:
		is_hidden = false
	else:
		is_hidden = true
