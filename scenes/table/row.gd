extends Control

var row_element_scene = load( "res://scenes/table/row element.tscn" )
var contents : Array
var sell_order := false

func _ready():
	#    ALIGN_LEFT = 0 --- Align rows to the left (default).
	#    ALIGN_CENTER = 1 --- Align rows centered.
	#    ALIGN_RIGHT = 2 --- Align rows to the right.
	#    ALIGN_FILL = 3 --- Expand row whitespaces to fit the width.
	# default: Left
	#$quantity.set_align( 2 )
	#$price.set_align( 2 )
	#$expires.set_align( 2 )
	pass

func hide_buy():
	sell_order = true
	$HBoxContainer/range.hide()
	$HBoxContainer/min_v.hide()

func set_contents( row : Array, headers : Array):
	contents = row
	$HBoxContainer/quantity.set_content( "[right]" + Utility.format_int_thousands(row[0]) + "[/right]" )
	$HBoxContainer/price.set_content( "[right]" + Utility.format_float_decimal(row[1]) + " ISK [/right]" )
	$HBoxContainer/location.set_content( row[2] )
	if !sell_order:
		var buy_range : String
		if row[3] == -1:
			buy_range = " Station"
		elif row[3] == 0:
			buy_range = " Solar system"
		elif row[3] == 100:
			buy_range = " Region"
		else:
			buy_range = " " + str(row[3]) + " jumps"
			
		$HBoxContainer/range.set_content( buy_range )
		$HBoxContainer/min_v.set_content( str(row[4]) )
	var expires : String = Utility.duration_seconds_format( row[5] )
	$HBoxContainer/expires.set_content( expires )
	
	var row_elements = $HBoxContainer.get_children()
	for i in range( $HBoxContainer.get_child_count() ):
		row_elements[i].set_width( headers[i].get( "rect_size" ).x )
		row_elements[i].set_align( headers[i].align )
		headers[i].connect( "new_width", row_elements[i], "set_width")


func _on_row_mouse_entered():
	$bg.show()


func _on_row_mouse_exited():
	$bg.hide()
