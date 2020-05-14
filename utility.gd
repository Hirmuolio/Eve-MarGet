extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print( 10%4)
	pass # Replace with function body.
	#test()

func test():
	var raw = "202000200.30"
	var formatted = format_decimal(  raw )
	print( "f: ", formatted)

func format_decimal( input : String ) -> String:
	var decimal_separator = "."
	var thousand_separator = " " #thin space
	
	var split = input.rsplit ( decimal_separator )
	if split.size() == 1:
		split.append( "00" )
	
	var output : String = ""
	
	var mod = split[0].length() % 3

	for i in range(0, split[0].length()):
		if i != 0 && i % 3 == mod:
			output += thousand_separator
		output += split[0][i]
	
	return output + decimal_separator + split[1]

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
	
	var seconds = in_seconds % 60
	
	
	return ""
