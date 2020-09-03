extends VBoxContainer

var header_scene = load( "res://scenes/table/header.tscn" )
var row_scene = load( "res://scenes/table/row.tscn" )

onready var row_cont_node = get_node( "ScrollContainer/row container" )

var sort_reverse := false
export var sell_orders := false

func _ready():
	if sell_orders:
		get_node("headers/range").hide()
		get_node("headers/min_v").hide()
	pass


func add_row( row_contents : Array ):
	var row_node = row_scene.instance()
	var headers = $headers.get_children()
	row_node.set_contents( row_contents, headers )
	if sell_orders:
		row_node.hide_buy()
	row_cont_node.add_child( row_node )

func clear_table():
	for child in get_node( "ScrollContainer/row container" ).get_children():
		child.queue_free()


func sort_by( index : int, sort_ascending : bool):
	print( "Sorting by index ", index)
	var unsorted = true
	var child_count : int = row_cont_node.get_child_count() 
	while unsorted:
		unsorted = false
		var children : Array = row_cont_node.get_children()
		for i in range(0, child_count - 1):
			if sort_ascending and children[i].contents[index] > children[i+1].contents[index]:
				unsorted = true
				row_cont_node.move_child( children[i+1], i)
			elif !sort_ascending and children[i].contents[index] < children[i+1].contents[index]:
					unsorted = true
					row_cont_node.move_child( children[i+1], i)
	pass

func _on_quantity_sort( sort_ascending : bool ):
	var index : int = 0
	sort_by( index, sort_ascending)


func _on_price_sort(sort_ascending : bool):
	var index = 1
	sort_by( index, sort_ascending)


func _on_location_sort(sort_ascending : bool):
	var index = 2
	sort_by( index, sort_ascending)


func _on_range_sort(sort_ascending : bool):
	var index = 3
	sort_by( index, sort_ascending)


func _on_min_v_sort(sort_ascending : bool):
	var index = 4
	sort_by( index, sort_ascending)


func _on_expires_sort(sort_ascending : bool):
	var index = 5
	sort_by( index, sort_ascending)
