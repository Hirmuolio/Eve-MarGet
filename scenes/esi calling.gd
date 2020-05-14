extends HTTPRequest

var response : JSONParseResult #Can be array or dictionary depending on the endpoint
var headers : Dictionary = {}
var response_code : int = 0
var attempts : int = 0

var success_codes = [200, 204, 304, 400, 404]

var base_url : String = 'https://esi.evetech.net'
var useragent = "Godot market tool"

signal call_parsed

func _ready():
	#var group_id = 115
	#yield( call_esi( "/v1/markets/groups/"+str(group_id) ), "completed" )
	#print( headers )
	#print( response.result )
	pass

func call_esi( route : String, payload : String = "", method : int = HTTPClient.METHOD_GET ):
	var call_completed = false
	while !call_completed:
		yield( make_call( route, payload , method ), "completed" )
		call_completed = yield( error_check(), "completed" )
	
	var return_thing : Dictionary = {}
	return_thing["response"] = response
	return_thing["headers"] = headers
	return_thing["response_code"] = response_code
	
	return return_thing


func make_call( route : String, payload : String = "", method : int = HTTPClient.METHOD_GET):
	print( "Calling ", route, payload, "...")
	var url : String = base_url + route
	var call_headers : Array = ["Content-Type: application/json", "user-agent: "+useragent]
	var use_ssl : bool = false
	
	var status = request(url, call_headers, use_ssl, method, payload )
	if status != 0:
		print( "Error ", status)
		print( route, payload, method)
	attempts = attempts + 1
	yield( self, "call_parsed" )

func error_check( ):
	if response_code in success_codes:
		# Success
		if response_code in [400, 404]:
			print( "Failed call ", response_code, " ", response.result)
		yield( get_tree().create_timer(0), "timeout" )
		return true
	else:
		# Some error
		var sleep = 0
		if response_code in [500, 502, 503, 504]:
			# Server error. Wait and retry
			sleep = min( pow(2, attempts) + randf(), 300)
		elif response_code in [520]:
			# Some other server error. Wait longer and retry
			sleep = 60
		elif response_code in [420]:
			# Error limit
			sleep = headers["x-esi-error-limit-reset"]
		print( "Error ", response_code, " ", response.result )
		print("Retrying in ", sleep, " seconds")
		yield( get_tree().create_timer(sleep), "timeout" )
		return false

func stringarr_to_dict( pool_str_arr : PoolStringArray):
	var dictionary = {}
	
	for string in pool_str_arr:
		var split = string.rsplit(":")
		dictionary[ split[0] ] = split[1]
	
	return dictionary

func _on_esi_calling_request_completed(_result, call_response_code, response_headers, body):
	response_code = call_response_code
	var json_body = JSON.parse(body.get_string_from_utf8())
	response = json_body
	headers = stringarr_to_dict( response_headers )

	emit_signal( "call_parsed" )

