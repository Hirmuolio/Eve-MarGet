extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
		history_dates.append( element["date"] )
		history_average.append( element["average"] )
		history_highest.append( element["highest"] )
		history_lowest.append( element["lowest"] )
		history_count.append( element["order_count"] )
		history_volume.append( element["volume"] )
