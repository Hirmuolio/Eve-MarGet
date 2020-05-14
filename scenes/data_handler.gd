extends Node


var names_ids : Dictionary = {}
var ids_names : Dictionary = {}
var ids_attributes : Dictionary = {}
var marketgroups : Dictionary = {}
var location_id_names : Dictionary = {}

var work_folder = "user://"

var esi_caller_scene = preload( "res://scenes/esi calling.tscn" )

signal image_loaded( image )
signal orders_loaded( orders )

func _ready():
	var dir = Directory.new()
	var folder = work_folder
	dir.open(folder)
	
	if dir.file_exists("marketgroups.json"):
		marketgroups = load_json(work_folder + "marketgroups.json")
	else:
		yield( esi_marketgroups(), "completed" )
		save_json(work_folder + "marketgroups.json", marketgroups)
	
	if dir.file_exists("names_ids.json") && dir.file_exists("ids_names.json"):
		names_ids = load_json(work_folder + "names_ids.json")
		ids_names = load_json(work_folder + "ids_names.json")
	else:
		var all_ids = list_item_ids()
		yield( esi_ids_to_names( all_ids ), "completed" )
		save_json(work_folder + "names_ids.json", names_ids)
		save_json(work_folder + "ids_names.json", ids_names)
	if dir.file_exists("location_id_names.json"):
		location_id_names = load_json(work_folder + "location_id_names.json")


	pass

func test():
	print( "It works" )

func load_json(file_path: String):
	#Get dictionary out of kson file
	#Returns the finished dictionary
	
	var loaded_file
	var text : String
	var dictionary : Dictionary
	
	loaded_file = File.new()
	loaded_file.open(file_path, loaded_file.READ)
	text = loaded_file.get_as_text()
	dictionary = parse_json(text)
	loaded_file.close()
	
	if dictionary == null:
		print( str( 'ERROR - Failed to load ', file_path ) )
		return {}
			
	return dictionary

func save_json(file_path: String, dictionary: Dictionary):
	var file = File.new()
	if file.open(file_path, File.WRITE) != 0:
		print( str( 'Error opening file ', file_path ) )
		return

	file.store_line(to_json(dictionary))
	file.close()

func list_item_ids():
	var all_item_ids : Array = []
	for group_id in marketgroups:
		for item_id in marketgroups[group_id]["types"]:
			if not item_id in all_item_ids:
				all_item_ids.append( item_id )
			
	return all_item_ids

func esi_ids_to_names( ids : Array ):
	var processed : int = 0
	var total : int = ids.size()
	var batch : int = 999
	var calls : int= 0
	while processed < ids.size():
		var esi_caller = esi_caller_scene.instance()
		add_child(esi_caller)
		var cutoff_ids = ids.slice(processed, min( processed+batch, total-1 ) )
		processed = processed + cutoff_ids.size()
		print( processed, "/", total )
		calls = calls + 1
		var response = yield( esi_caller.call_esi( "/v3/universe/names/", str(cutoff_ids), HTTPClient.METHOD_POST ), "completed" )
		esi_caller.queue_free()
		#yield( get_tree().create_timer(4), "timeout" )
		if response["response_code"] != 200:
			print( "FATAL ERROR failed to get names for IDs ", response["response_code"])
			print( "processed: ", processed )
			print( "Number of IDs: ", cutoff_ids.size() )
			print( cutoff_ids.size() )
			print( cutoff_ids )
		for response_element in response["response"].result:
			var thing_name = response_element["name"]
			var thing_id = str( response_element["id"] )
			names_ids[thing_name] = thing_id
			ids_names[ thing_id ] = thing_name
	print( "IDs and names done")


func esi_marketgroups():
	var esi_caller = esi_caller_scene.instance()
	add_child(esi_caller)
	var response = yield( esi_caller.call_esi( "/v1/markets/groups/" ), "completed" )
	esi_caller.queue_free()
	var marketgroup_list = response["response"].result
	
	yield( process_marketgroups( marketgroup_list ), "completed")


func esi_get_orders( item_id : String):
	var region : String = "10000002"
	var scope : String = "/v1/markets/"+ region + "/orders/"
	#var all_orders : Array = []
	
	# Call first page
	var esi_caller = esi_caller_scene.instance()
	add_child(esi_caller)
	var payload = "?datasource=tranquility&type_id=" + item_id
	var response = yield( esi_caller.call_esi( scope+payload ), "completed" )
	esi_caller.queue_free()
	
	if "X-Pages" in response["headers"] && int(response["headers"]["X-Pages"]) != 1:
		var pages = response["headers"]["X-Pages"]
		print( "ERROR MANY PAGES ", pages)
	
	
	emit_signal("orders_loaded", [response])

func get_station_name( station_id : int ):
	var scope : String = "/v2/universe/stations/" + str(station_id) + "/"
	var esi_caller = esi_caller_scene.instance()
	add_child(esi_caller)
	var response = yield( esi_caller.call_esi( scope ), "completed" )
	esi_caller.queue_free()
	
	if response["response_code"] != 200:
		location_id_names[ str( station_id ) ] = "POS"
		save_json(work_folder + "location_id_names.json", location_id_names)
		return "POS"
	var station_name = response["response"].result["name"]
	
	location_id_names[ str( station_id ) ] = station_name
	save_json(work_folder + "location_id_names.json", location_id_names)
	
	return station_name

func server_get_image( item_id : String ):
	
	var dir = Directory.new()
	var folder = work_folder + "/icons/"
	dir.open(folder)
	if dir.file_exists(item_id+".png"):
		var image = Image.new()
		var error = image.load(folder + item_id+".png")
		if error != OK:
			print("error loading the image: " + folder + item_id+".png")
		
		var texture = ImageTexture.new()
		texture.create_from_image(image)
	
		emit_signal( "image_loaded", texture )
		return
	
	#https://images.evetech.net/types/587/icon
	var url = "https://images.evetech.net/types/"+ item_id +"/icon"
	var request_node = HTTPRequest.new()
	add_child(request_node)
	request_node.connect("request_completed", self, "image_request_completed", [item_id])
	
	var error = request_node.request(url)
	if error != OK:
		push_error( "Failed to load image" )

func image_request_completed( _result, response_code, _headers, body, item_id ):
	if response_code != 200:
		print( "Failed to get image. Error ", response_code)
	print( "Got some image from server" )
	var image : Image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
		return
	var folder = work_folder + "/icons/"
	var dir = Directory.new()
	dir.open(work_folder)
	if not dir.dir_exists("icons"):
		print( "No icons folder")
		dir.make_dir("icons")
	image.save_png ( folder +item_id + ".png" )
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	emit_signal( "image_loaded", texture )

func process_marketgroups( marketgroup_list : Array):
	
	# Get info on all individual groups
	#print( marketgroup_list )
	print( "Processing marketgroups")
	
	var n = 1
	var total = marketgroup_list.size()
	var all_responses : Array = []
	var url = "/v1/markets/groups/"
	var multicaller_scene = load( "res://scenes/esi multi call.tscn" )
	
	var multicaller = multicaller_scene.instance()
	add_child(multicaller)
	
	while marketgroup_list.size() != 0:
		print( n, "/", total)
		var paths_to_call : PoolStringArray = []
		var values_to_remove : Array = []
		var i : int = 0
		while i <= min( 31, marketgroup_list.size() - 1):
			paths_to_call.append( url + str( marketgroup_list[i] ) + "/" )
			values_to_remove.append( marketgroup_list[i] )
			n = n + 1
			i = i + 1
		for value in values_to_remove:
			marketgroup_list.erase( value )
		
		if paths_to_call.size() != 0:
			var responses : Array = yield( multicaller.many_esi_calls(paths_to_call), "completed" )
			all_responses = all_responses + responses
	
	multicaller.queue_free()
	
	print( "Putting responses together" )
	for response in all_responses:
		var group_info : Dictionary = response["response"].result
		var group_id = str( group_info["market_group_id"] )
		group_info["child_group_id"] = []
		marketgroups[ group_id ] = group_info
	
	print( "Final processing" )
	# Add child info
	for group in marketgroups:
		if "parent_group_id" in marketgroups[group]:
			var pareng_group_id = str( marketgroups[group]["parent_group_id"] )
			var group_id = str( marketgroups[group]["market_group_id"] )
			marketgroups[ pareng_group_id ]["child_group_id"].append( group_id )
	print( "Market group processing done")
