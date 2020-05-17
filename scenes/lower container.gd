extends TabContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var sell_headers = ["Quantity", "Price", "Location", "Expires"]
	var sell_aligns = [2, 2, 0, 2]
	for i in range (sell_headers.size() ):
		$"Sell orders".add_header( sell_headers[i], sell_aligns[i] )
	
	var buy_headers = ["Quantity", "Price", "Location", "Range", "Min volume", "Expires"]
	var buy_aligns = [2, 2, 0, 2, 2, 2]
	for i in range (buy_headers.size() ):
		$"Buy orders".add_header( buy_headers[i], buy_aligns[i] )

func set_orders( esi_response : Array ):
	$"Buy orders".clear_table()
	$"Sell orders".clear_table()
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
		var location : String
		if str(location_id) in DataHandler.location_cache:
			location = DataHandler.location_cache[ str(location_id) ]["name"]
		else:
			location = yield( DataHandler.get_station_name( location_id ), "completed" )
		
		
		# "issued": "2020-05-09T22:12:14Z",
		# "duration": 90,
		var duration : int = order["duration"]
		var issued : String = order["issued"]
		var datetime_order = Utility.string_time_to_dict( issued )
		
		var unix_order = OS.get_unix_time_from_datetime( datetime_order )
		var expires_seconds = unix_order - unix_now + duration * ( 24 * 60 * 60)
		
		var expires : String = Utility.duration_seconds_format( expires_seconds )
		
		if order["is_buy_order"] == false:
			row = [ quantity, price, location, expires ]
			$"Sell orders".add_row( row )
		else:
			row = [ quantity, price, location, buy_range, min_volume, expires ]
			$"Buy orders".add_row(row)
