extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var sell_headers = ["Quantity", "Price", "Location", "Expires"]
	var sell_aligns = [2, 2, 0, 2]
	get_node( "VBoxContainer/sell orders").set_label( "Sell orders")
	get_node( "VBoxContainer/sell orders").set_headers( sell_headers, sell_aligns)
	
	var buy_headers = ["Quantity", "Price", "Location", "Range", "Min volume", "Expires"]
	var buy_aligns = [2, 2, 0, 2, 2, 2]
	get_node( "VBoxContainer/buy orders").set_label( "Buy orders")
	get_node( "VBoxContainer/buy orders").set_headers( buy_headers, buy_aligns)

func set_orders( esi_response : Array ):
	get_node( "VBoxContainer/sell orders").clear_orders()
	get_node( "VBoxContainer/buy orders").clear_orders()
	var time_now = OS.get_datetime ( true )
	var unix_now = OS.get_unix_time_from_datetime( time_now )
	var new_orders = esi_response[0]["response"].result
	for order in new_orders:
		var row := []
		var quantity : String = str( order["volume_remain"] )
		var price : String = Utility.format_decimal( str( order["price"] ) ) + " ISK"
		var min_volume : String = str( order["min_volume"] )
		
		var buy_range : String
		if order["range"].is_valid_integer():
			buy_range = order["range"] + " jumps"
		else:
			buy_range = order["range"]
		
		var location_id : int = order["location_id"]
		
		# Jita 4-4 = 60003760
#		if str( station_id ) in location_id_names:
#		yield(get_tree(),"idle_frame")
#		return location_id_names[ str( station_id ) ]
		
		var location : String
		if str(location_id) in DataHandler.location_id_names:
			location = DataHandler.location_id_names[ str(location_id) ]
		else:
			location = yield( DataHandler.get_station_name( location_id ), "completed" )
		
		
		# "issued": "2020-05-09T22:12:14Z",
		# "duration": 90,
		var duration : int = order["duration"]
		var issued : String = order["issued"]
		var datetime_order = Utility.string_time_to_dict( issued )
		
		var unix_order = OS.get_unix_time_from_datetime( datetime_order )
		var expires_seconds = unix_order - unix_now
		
		var expires : String
		
		if order["is_buy_order"] == false:
			row = [ quantity, price, location, expires ]
			get_node( "VBoxContainer/sell orders").add_order( row )
		else:
			row = [ quantity, price, location, buy_range, min_volume, expires ]
			get_node( "VBoxContainer/buy orders").add_order(row)
	pass
