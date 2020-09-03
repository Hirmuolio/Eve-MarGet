extends Control

onready var icon_node := get_node( "VBoxContainer/upper container/icon" )
onready var name_node := get_node("VBoxContainer/upper container/texts container/name")
onready var category_node := get_node("VBoxContainer/upper container/texts container/groups")
onready var orders_node := get_node( "VBoxContainer/lower container" )
onready var history_node := get_node("VBoxContainer/lower container/history" )


# Called when the node enters the scene tree for the first time.
func _ready():
	if DataHandler.connect( "image_loaded", self, "set_icon" ) != OK:
		print( "Failed to connect image loading" )
	if DataHandler.connect( "orders_loaded", self, "set_orders" ) != OK:
		print( "Failed to connect order loading" )
	if DataHandler.connect( "history_loaded", self, "set_history" ) != OK:
		print( "Failed to connect order loading" )
	


func on_item_selected( item_id : String):
	print( "Selected ", item_id)
	name_node.set("text", DataHandler.ids_names[item_id])
	DataHandler.server_get_image( item_id )
	DataHandler.esi_get_orders( item_id )

#---
# Data setting functions work with signals. They run when the data is ready.
#---

func set_icon( new_icon : Texture ):
	icon_node.set( "texture", new_icon)

func set_orders( esi_response : Array):
	orders_node.set_orders( esi_response )

func set_history( esi_response : Array ):
	history_node.set_history( esi_response )
