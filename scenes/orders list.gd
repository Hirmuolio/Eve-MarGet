extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_label( new_label : String ):
	$Label.set("text", new_label)

func set_headers( header : Array, align : Array):
	for i in range (header.size() ):
		$table.add_header( header[i], align[i] )

func clear_orders():
	$table.clear_table()

func add_order( new_order : Array):
	$table.add_row( new_order )
