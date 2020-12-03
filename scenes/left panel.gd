extends Control


signal item_selected( item_id )


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func initialize():
	get_node("vertical container/market tree").initialize()
	pass


func _on_market_tree_item_id_selected(item_id):
	emit_signal( "item_selected", item_id )
