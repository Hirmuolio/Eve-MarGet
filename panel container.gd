extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var tree_node = get_node( "left panel/vertical container/market tree" )
	var right_panel_node = get_node( "right panel" )
	tree_node.connect("item_id_selected", right_panel_node, "on_item_selected")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
