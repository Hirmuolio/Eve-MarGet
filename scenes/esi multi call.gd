extends Node

var esi_caller_scene = preload( "res://scenes/esi calling.tscn" )

func _ready():
	pass

func many_esi_calls(routes : PoolStringArray):
	
	if routes.size() > 32:
		print( "Error too many calls" )
	var coroutine_list = []
	var callers_list = []
	var response_list = []

	# Make many calls
	for route in routes:
		var esi_caller = esi_caller_scene.instance()
		add_child(esi_caller)
		coroutine_list.append( esi_caller.call_esi( route ) )
		callers_list.append( esi_caller )
	
	# Wait for many calls to be finished
	#for coroutine in coroutine_list:
	#	if coroutine.is_valid():
	#		yield(coroutine, "completed")
	for caller in callers_list:
		while not caller.response_code in [200, 204, 304, 400, 404]:
			#OS.delay_msec(500)
			yield(Engine.get_main_loop(), "idle_frame")

	
	# Get the results from many calls
	for caller in callers_list:
		var response : Dictionary = {}
		response["response"] = caller.response
		response["headers"] = caller.headers
		response["response_code"] = caller.response_code
		
		response_list.append( response )
		caller.queue_free()
	return response_list

func many_esi_calls_data( route : String, loads : Array):
	var coroutine_list = []
	var callers_list = []
	var response_list = []
	
	while loads.size() != 0:
		var cutoff_loads = loads.slice(0, min( 31, loads.size()-1 ) )
		
		for payload in cutoff_loads:
			var esi_caller = esi_caller_scene.instance()
			add_child(esi_caller)
			coroutine_list.append( esi_caller.call_esi( route, payload ) )
			callers_list.append( esi_caller )
			loads.erase( payload )
	
	for caller in callers_list:
		while not caller.response_code in [200, 204, 304, 400, 404]:
			yield(Engine.get_main_loop(), "idle_frame")
	
	for caller in callers_list:
		var response : Dictionary = {}
		response["response"] = caller.response
		response["headers"] = caller.headers
		response["response_code"] = caller.response_code
		
		response_list.append( response )
		caller.queue_free()
	return response_list
