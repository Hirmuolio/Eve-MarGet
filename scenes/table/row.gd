extends HBoxContainer

var row_element_scene = load( "res://scenes/table/row element.tscn" )
var contents : Array
var sell_order := true

func _ready():
	pass # Replace with function body.

func hide_buy():
	$range.hide()
	$min_v.hide()

func set_contents( row : Array, headers : Array):
	contents = row
	$quantity.set_content( str(row[0]) )
	$price.set_content( str(row[1]) + " ISK" )
	$location.set_content( row[2] )
	if !sell_order:
		var buy_range : String
		if row[3] == -1:
			buy_range = "Station"
		elif row[3] == 0:
			buy_range = "Solar system"
		elif row[3] == 100:
			buy_range = "Region"
		else:
			buy_range = str(row[3]) + " jumps"
			
		$range.set_content( buy_range )
		$min_v.set_content( row[4] )
	$expires.set_content( str(row[5]) )
	
	var row_elements = get_children()
	for i in range( get_child_count() ):
		row_elements[i].set_width( headers[i].get( "rect_size" ).x )
		row_elements[i].set_align( headers[i].align )
		headers[i].connect( "new_width", row_elements[i], "set_width")

