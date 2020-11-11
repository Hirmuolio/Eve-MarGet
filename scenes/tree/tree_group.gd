extends Node

class_name tree_group
func get_class(): return "tree_group"

var group_scene = load("res://scenes/tree/tree_group.tscn")
var item_scene = load("res://scenes/tree/tree_item.tscn")

# Properties of this group
var group_name : String
var group_id : String
var is_hidden : bool = false
var is_collapsed : bool = true
const is_group : bool = true

var child_groups := []
var child_items := []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_group( new_group_id : String ):
	group_id = new_group_id
	group_name = DataHandler.marketgroups[group_id]["name"]
	set_name(group_name)

	for child_group_id in DataHandler.marketgroups[group_id]["child_group_id"]:
		var group : tree_group = group_scene.instance()
		add_child(group )
		child_groups.append(group)
		group.create_group( child_group_id )
	for item_id in DataHandler.marketgroups[group_id]["types"]:
		var item : tree_item = item_scene.instance()
		add_child(item )
		child_items.append(item)
		item.create_item( str(item_id) )

func filter( search_term : String ):
	for child in get_children():
		child.filter( search_term )

func hide_if_empty():
	for child in child_groups:
		child.hide_if_empty()
	
	is_hidden = true
	for child in get_children():
		if !child.is_hidden:
			is_hidden = false
			return
