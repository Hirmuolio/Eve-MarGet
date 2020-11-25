extends Control



func _ready():
	
	$HBoxContainer/MenuButton.text = DataHandler.region_cache[ str(Config.region_id) ]
	
	add_regions()
	$HBoxContainer/MenuButton.get_popup().allow_search = true
	$HBoxContainer/MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	pass # Replace with function body.

func _on_item_pressed(region_id : int):
	Config.region_id = region_id
	
	var popup : PopupMenu = $HBoxContainer/MenuButton.get_popup()
	var index : int = popup.get_item_index(region_id)
	var region_name : String = popup.get_item_text(index)
	print( region_name )
	$HBoxContainer/MenuButton.text = region_name

func add_regions():
	
	for region_key in DataHandler.region_cache:
		# region_key = region id
		# "10000001":"Derelik" and so on
		$HBoxContainer/MenuButton.get_popup().add_item( DataHandler.region_cache[region_key], int(region_key) )
		pass
	pass
