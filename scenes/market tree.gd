extends Tree

var root
var tree_dict := {}


signal item_id_selected( item_id )

# Called when the node enters the scene tree for the first time.
func _ready():
	$tree_data.fill_data()
	
	create_tree()


func create_tree():
	# Add top level groups
	clear()
	root = create_item()
	set_hide_root(true)
	for node in $tree_data.get_children():
		add_group( node, root )


func add_group( node : tree_group, parent : TreeItem ):
	if node.is_hidden:
		return
	var group = create_item(parent)
	group.set_text(0, node.group_name )
	group.set_metadata(0, node)
	group.collapsed = node.is_collapsed
	#group.connect("item_selected", self, "_on_Timer_timeout")
	
	for group_node in node.child_groups:
		add_group(group_node, group)
	
	for item_node in node.child_items:
		add_item(item_node, group)


func add_item( node : tree_item, parent : TreeItem ):
	if node.is_hidden:
		return
	var group = create_item(parent)
	group.set_text(0, node.item_name)
	group.set_metadata(0, node)

func _on_market_tree_cell_selected():
	var item : TreeItem = get_selected()
	var node = item.get_metadata(0)
	
	print( node.is_hidden )
	
	if node.is_group:
		item.collapsed = !item.collapsed
		node.is_collapsed = item.collapsed
		item.deselect(0)
	else:
		emit_signal("item_id_selected", node.item_id)


func _on_search_field_text_changed():
	var search_term : String = get_node( "../HBoxContainer/search_field" ).text
	print( search_term )
	
	$tree_data.filter( search_term )
	create_tree()



