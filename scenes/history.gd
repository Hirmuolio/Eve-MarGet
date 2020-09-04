extends Control



func _ready():
	pass


func datetime_from_string( date_string : String ) -> Dictionary:
	var string_arr := date_string.rsplit("-")
	var datetime : Dictionary = {
		"year": string_arr[0],
		"month": string_arr[1],
		"day": string_arr[2],
		"hour": 0,
		"minute":0,
		"second":0
	}
	return datetime



func set_history(response : Array):
	# Format the market history into arrays for easier handling
	# {
	# "average": 3614404,
	# "date": "2019-08-02",
	# "highest": 3711999.99,
	# "lowest": 3610350,
	# "order_count": 2231,
	# "volume": 1356862
	# },
	
	var history_dates : Array
	var history_average : Array
	var history_highest : Array
	var history_lowest : Array
	var history_count : Array
	var history_volume : Array
	
	for element in response[0]["response"].result:
		history_dates.append( datetime_from_string( element["date"] ) )
		history_average.append( element["average"] )
		history_highest.append( element["highest"] )
		history_lowest.append( element["lowest"] )
		history_count.append( element["order_count"] )
		history_volume.append( element["volume"] )
	
	# Dates to days
	$graph.plot_data( history_dates, history_average )
