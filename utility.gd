extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func format_decimal( input : String ) -> String:
	# Formats string number
	# 100000,00 -> 100 000.00
	var decimal_separator = "."
	var thousand_separator = " " #thin space
	
	var split : PoolStringArray = input.rsplit ( decimal_separator )
	if split.size() == 1:
		split.append( "00" )
	if split[1].length() == 1:
		split[1] = split[1] + "0"
	
	var output : String = ""
	
	var mod = split[0].length() % 3

	for i in range(0, split[0].length()):
		if i != 0 && i % 3 == mod:
			output += thousand_separator
		output += split[0][i]
	
	return output + decimal_separator + split[1]

func format_float_decimal( input : float ) -> String:
	return format_decimal( str(input) )

func format_int_thousands( input : int ) -> String:
	var thousand_separator = " " #thin space
	
	var temp_str = str(input)
	var output : String = ""
	
	for i in range(0, temp_str.length() ):
		if i != 0 && i % 3 == temp_str.length() % 3:
			output += thousand_separator
		output += temp_str[i]
	
	return output

func string_time_to_dict( time : String ) -> Dictionary:
	# Turns string like "2020-05-09T22:12:14Z" into dictionary
	var output = {}
	
	time = time.replace("T", "-")
	time = time.replace(":", "-")
	time = time.replace("Z", "")
	
	var splitted = time.split( "-" )
	
	output["year"] = int( splitted[0] )
	output["month"] = int( splitted[1] )
	output["day"] = int( splitted[2] )
	output["hour"] = int( splitted[3] )
	output["minute"] = int( splitted[4] )
	output["second"] = int( splitted[5] )
	
	return output

func duration_seconds_format( in_seconds : int) -> String:
	# Turns seconds int daus, hours, minutes and seconds
	
	var seconds : int = in_seconds % (24*60*60)
	var days : int = int( float( in_seconds - seconds ) / float(24*60*60) )
	
	seconds = seconds % ( 60 * 60 )
	var hours : int = int( float( in_seconds - days * (24*60*60) - seconds ) / ( 60*60.0 ) )
	
	seconds = seconds % ( 60 )
	var minutes : int = int( float( in_seconds - days * (24*60*60) - hours * (60*60) - seconds ) / 60.0 )
	
	var output : String = str(days) + "d " + str(hours) + "h " + str(minutes) + "m " + str(seconds) + "s"
	return output

func array_multiply( array : Array, multiplier : float ) -> Array:
	var return_arr : Array = []
	for element in array:
		return_arr.append( element * multiplier)
	return return_arr

func array_add( array : Array, addition : float ) -> Array:
	var return_arr : Array = []
	for element in array:
		return_arr.append( element + addition)
	return return_arr

func array_normalize( array : Array ) -> Array:
	# Normalizes all values to below 1
	var return_arr : Array = []
	var max_value = array.max()
	for element in array:
		return_arr.append( element / max_value)
	return return_arr

func array_normalize_01( array : Array ) -> Array:
	# Normalizes all values in between 0-1
	var return_arr : Array = []
	var max_value = array.max()
	var min_value = array.min()
	for element in array:
		return_arr.append( ( element - min_value ) / ( max_value - min_value ) )
	return return_arr
