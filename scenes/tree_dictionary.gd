extends Node


var group_scene = load("res://scenes/tree/tree_group.tscn")
var item_scene = load("res://scenes/tree/tree_item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fill_data():
	# Add all the top level groups
	# The tree_group will handle their contents
	for group_id in DataHandler.marketgroups:
		if not "parent_group_id" in DataHandler.marketgroups[group_id]:
			var group : tree_group = group_scene.instance()
			add_child(group )
			var branch_name = "koromon"
			group.create_group( group_id )

func filter( search_term : String ):
	
	for child in get_children():
		child.filter( search_term )
	
	for child in get_children():
		child.hide_if_empty()
