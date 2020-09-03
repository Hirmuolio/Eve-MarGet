extends Control


var resizing := false
var align = 0
var mouse_pos_x : int
var separator_width : int = 10

var sort_ascending : bool = false

export var label : String

signal new_width( new_width )
signal sort(sort_state)

func _ready():
	set_label( label )
	separator_width = get_node("VSeparator").get("rect_size").x
	pass

func _process(delta):
	pass


func _input(event):
	if resizing and event.is_class('InputEventMouseMotion'):	
		mouse_pos_x = event.position.x
		set_width( mouse_pos_x )


func set_label( new_label : String ):
	$Label.set( "text", new_label )

func set_width( mouse_pos_x : int):
	var new_rect = Vector2( mouse_pos_x + int(separator_width/2 + 0.5 ) , 0 ) - get_global_position()
	set("rect_size" , new_rect)
	set("rect_min_size" , new_rect)
	emit_signal( "new_width", new_rect.x )

func _on_TextureButton_button_down():
	resizing = true
	var mouse_pos_x : int = get_viewport().get_mouse_position().x 
	set_width( mouse_pos_x )
	


func _on_TextureButton_button_up():
	resizing = false


func _on_sort_button_button_down():
	print( "Sort signal" )
	sort_ascending = !sort_ascending
	emit_signal("sort", sort_ascending)
