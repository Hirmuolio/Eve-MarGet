extends HBoxContainer

var row_element_scene = load( "res://scenes/table/row element.tscn" )

func _ready():
	pass # Replace with function body.


func set_contents( row : Array, headers : Array):
	for i in range( row.size() ):
		add_element( row[i], headers[i] )


func add_element( contents : String, paired_header : Node ):
	var row_node = row_element_scene.instance()
	row_node.set_content( contents )
	row_node.set_width( paired_header.get( "rect_size" ).x )
	row_node.set_align( paired_header.align )
	paired_header.connect( "new_width", row_node, "set_width")
	add_child( row_node )
