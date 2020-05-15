extends Control


var resizing := false
var align = 0

signal new_width( new_width )
signal sort

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_class('InputEventMouseMotion'):		
		if resizing:
			var movement : int = event.relative.x
			var new_rect : Vector2 = get("rect_size") + Vector2( movement, 0 )
			set("rect_size" , new_rect)
			set("rect_min_size" , new_rect)
			emit_signal( "new_width", new_rect.x )

func set_label( new_label : String ):
	$Label.set( "text", new_label )

func set_width( new_width : int):
	var new_rect := Vector2( new_width, get("rect_size").y )
	set("rect_size" , new_rect)

func _on_TextureButton_button_down():
	resizing = true


func _on_TextureButton_button_up():
	resizing = false


func _on_sort_button_button_down():
	emit_signal("sort")
