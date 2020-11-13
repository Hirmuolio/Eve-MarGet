extends Tree

var root
var tree_dict := {}

var searc_active := false


signal item_id_selected( item_id )

# Called when the node enters the scene tree for the first time.
func _ready():
	$tree_data.fill_data()
	
	create_tree()


func create_item_tree():
	# Creates tree without any groups. Only items
	clear()
	root = create_item()
	set_hide_root(true)
	
	# get all the items
	var item_nodes := []
	for node in $tree_data.get_children():
		item_nodes += node.get_items()
	
	# Add all items
	for node in item_nodes:
		add_item(node, root)

func create_flattened_tree():
	# Creates tree with only top level groups
	clear()
	root = create_item()
	set_hide_root(true)
	# Add top level groups
	for node in $tree_data.get_children():
		if node.is_hidden:
			continue
		
		var item = add_group( node, root )
		
		# Add items of this group
		var item_nodes = node.get_items()
		
		for item_node in item_nodes:
			if !item_node.is_hidden:
				add_item(item_node, item)
		


func create_tree():
	# Creates full tree
	clear()
	root = create_item()
	set_hide_root(true)
	# Add top level groups
	for node in $tree_data.get_children():
		grow_group( node, root )

func grow_group( node : tree_group, parent : TreeItem ):
	# Adds a group and everything below it
	if node.is_hidden:
		return
	
	# Add this group
	var item : TreeItem = add_group( node, parent )
	
	# Grow child groups
	for group_node in node.child_groups:
		grow_group(group_node, item)
	
	# Add items of this group
	for item_node in node.child_items:
		if !item_node.is_hidden:
			add_item(item_node, item)
	pass

func add_group( node : tree_group, parent : TreeItem ) -> TreeItem:
	var group = create_item(parent)
	group.set_text(0, node.group_name )
	group.set_metadata(0, node)
	group.collapsed = node.is_collapsed
	return group


func add_item( node : tree_item, parent : TreeItem ):
	
	var group = create_item(parent)
	group.set_text(0, node.item_name)
	group.set_metadata(0, node)

func _on_market_tree_cell_selected():
	var item : TreeItem = get_selected()
	var node = item.get_metadata(0)
	
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
	
	if search_term.length() < Config.min_search_length:
		if searc_active:
			create_tree()
			searc_active = false
	else:
		searc_active = true
		if Config.search_mode == 0:
			create_item_tree()
		elif Config.search_mode == 1:
			create_flattened_tree()
		else:
			create_tree()



