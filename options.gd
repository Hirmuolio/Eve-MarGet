extends Control


func _ready():
	hide()
	$"option fields/search display".add_options( ["Ungrouped", "Top groups", "All groups"] )
	$"option fields/search mode".add_options( ["Normal search", "Exact match only", "Subsequence search"] )
	#open_options()
	pass

func open_options():
	$"option fields/search length".set_value( Config.min_search_length )
	$"option fields/search display".set_value( Config.search_display_mode )
	$"option fields/search mode".set_value( Config.search_mode )
	show()

func close_options():
	hide()

func _on_right_panel_open_options():
	open_options()

func _on_Button_pressed():
	close_options()


func _on_search_length_content_change(new_value):
	Config.min_search_length = new_value

func _on_search_display_content_change(new_value):
	Config.search_display_mode = new_value

func _on_search_mode_content_change(new_value):
	Config.search_mode = new_value
