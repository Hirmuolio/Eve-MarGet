extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield( DataHandler.load_caches(), "completed" )
	
	if DataHandler.ready == false:
		print( "ERROR - DataHandler not ready")
	
	# Nodes that need the data from DataHandler:
	
	get_node( "VBoxContainer/top panel/region selector").initialize()
	get_node("VBoxContainer/panel container/left_panel").initialize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
