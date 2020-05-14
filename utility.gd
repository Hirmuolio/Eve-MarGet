extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#test()

func test():
	# 2d 12h 8m 40s
	var raw = 216520
	var formatted = duration_seconds_format(  raw )
	print( "f: ", formatted)

func format_decimal( input : String ) -> String:
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
	var days : int = ( in_seconds - seconds ) / (24*60*60)
	
	seconds = seconds % ( 60 * 60 )
	var hours : int = ( in_seconds - days * (24*60*60) - seconds ) / ( 60*60 )
	
	seconds = seconds % ( 60 )
	var minutes : int = ( in_seconds - days * (24*60*60) - hours * (60*60) - seconds ) / 60
	
	var output : String = str(days) + "d " + str(hours) + "h " + str(minutes) + "m " + str(seconds) + "s"
	return output
