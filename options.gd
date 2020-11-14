extends Control


func _ready():
	$"option fields/search display".add_options( ["Ungrouped", "Top groups", "All groups"] )
	open_options()
	pass

func open_options():
	$"option fields/search length".set_value( Config.min_search_length )
	$"option fields/search display".set_value( Config.search_display_mode )
	show()

func close_options():
	hide()


func _on_right_panel_open_options():
	open_options()


func _on_search_length_content_change(new_value):
	Config.min_search_length = new_value


func _on_search_display_content_change(new_value):
	Config.search_display_mode = new_value


func _on_Button_pressed():
	close_options()
