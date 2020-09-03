extends TabContainer


func _ready():
	pass

func set_orders( esi_response : Array ):
	$"Buy orders".clear_table()
	$"Sell orders".clear_table()
	var time_now = OS.get_datetime ( true )
	var unix_now = OS.get_unix_time_from_datetime( time_now )
	var new_orders = esi_response[0]["response"].result
	for order in new_orders:
		var row := []
		var quantity : int = order["volume_remain"]
		var price : float = order["price"]
		var min_volume : int = order["min_volume"]
		
		var buy_range : int
		if order["range"].is_valid_integer():
			buy_range = int(order["range"])
		elif order["range"] == "region":
			buy_range = 100
		elif order["range"] == "solarsystem":
			buy_range = 0
		elif order["range"] == "station":
			buy_range = -1
		else:
			# Should never happen
			buy_range = -2
		
		var location_id : int = order["location_id"]
		
		# Jita 4-4 = 60003760
		var system_id = order["system_id"]
		var location : String = yield( DataHandler.get_station_name( location_id, system_id ), "completed" )
		
		
		# "issued": "2020-05-09T22:12:14Z",
		# "duration": 90,
		var duration : int = order["duration"]
		var issued : String = order["issued"]
		var datetime_order = Utility.string_time_to_dict( issued )
		
		var unix_order = OS.get_unix_time_from_datetime( datetime_order )
		var expires_seconds = unix_order - unix_now + duration * ( 24 * 60 * 60)
		
		#var expires : String = Utility.duration_seconds_format( expires_seconds )
		
		row = [ quantity, price, location, buy_range, min_volume, expires_seconds ]
		if order["is_buy_order"]:
			$"Buy orders".add_row(row)
		else:
			$"Sell orders".add_row( row )
