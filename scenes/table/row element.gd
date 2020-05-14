extends HBoxContainer



func _ready():
	pass


func set_width( new_width : int):
	var new_rect : Vector2 = Vector2( new_width, get("rect_size").y )
	set("rect_size" , new_rect)
	set("rect_min_size" , new_rect)

func set_content( new_content : String ):
	$Label.set( "text", new_content )

func set_align( align ):
	$Label.set( "align", align)
