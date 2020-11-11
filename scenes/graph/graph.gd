extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


func check_flow_of_time( datetime_array : Array ) -> void:
	# I really hope the dates are always in ascending order from ESI
	for i in range(datetime_array.size() ):
		if OS.get_unix_time_from_datetime( datetime_array[i] ) > OS.get_unix_time_from_datetime( datetime_array[i-1] ):
			print( "ERROR Dates not in right order!" )

func plot_data( dates : Array, y_values : Array ):
	# x_val are datetimes
	# y_val are floats (or integers)
	check_flow_of_time( dates )
	
	var size_limit = get("rect_size")
	
	var x_values : Array
	var min_date = OS.get_unix_time_from_datetime( dates[0] )
	var max_date = OS.get_unix_time_from_datetime( dates[-1] )
	
	for date in dates:
		var x_value : int = OS.get_unix_time_from_datetime( date ) * ( max_date - min_date ) / size_limit.x - min_date
		x_values.append( x_value )
	
	var y_values_normalized : Array
	
	
	plot_figure( x_values, y_values_normalized )

func plot_figure( x_values, y_values ):
	# x_vals are normalized to the figure
	pass
