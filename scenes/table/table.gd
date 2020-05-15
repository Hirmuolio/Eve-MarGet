extends VBoxContainer

var header_scene = load( "res://scenes/table/header.tscn" )
var row_scene = load( "res://scenes/table/row.tscn" )

onready var row_cont_node = get_node( "ScrollContainer/row container" )

var sort_by : int = 1
var sort_reverse = false

func _ready():
	pass
	#test()

func test():
	add_header( "test1" )
	add_header( "test2" )
	var row = ["aaaaaaaa", "bbbbbbb"]
	add_row( row )
	add_row( row )


func add_header( label : String, align := 0 ):
	var header_node = header_scene.instance()
	header_node.set_label( label )
	header_node.align = align
	$headers.add_child( header_node )

func do_sort():
	pass

func add_row( row_contents : Array ):
	var row_node = row_scene.instance()
	var headers = $headers.get_children()
	row_node.set_contents( row_contents, headers )
	row_cont_node.add_child( row_node )

func clear_table():
	for child in get_node( "ScrollContainer/row container" ).get_children():
		child.queue_free()
