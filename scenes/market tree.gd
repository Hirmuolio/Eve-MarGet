extends Tree

var root

signal item_id_selected( item_id )

# Called when the node enters the scene tree for the first time.
func _ready():
	root = create_item()
	set_hide_root(true)
	create_tree()

func create_tree():
	for group_id in DataHandler.marketgroups:
		if not "parent_group_id" in DataHandler.marketgroups[group_id]:
			add_group( DataHandler.marketgroups[group_id] )


func add_group( group_dic : Dictionary):
	var group = create_item(root)
	#group.add_button ( 0, icon)
	group.set_text(0, group_dic["name"]+" ")
	group.collapsed = true
	for child_group_id in group_dic["child_group_id"]:
		add_subgroup(child_group_id, group)
	for item_id in group_dic["types"]:
		add_item(item_id, group)
	

func add_subgroup(group_id : String, parent : TreeItem):
	var group = create_item(parent)
	group.set_text(0, DataHandler.marketgroups[group_id]["name"]+" ")
	group.collapsed = true
	for child_group_id in DataHandler.marketgroups[group_id]["child_group_id"]:
		add_subgroup(child_group_id, group)
	for item_id in DataHandler.marketgroups[group_id]["types"]:
		add_item( str(item_id), group)


func add_item( item_id : String, parent : TreeItem ):
	var group = create_item(parent)
	group.set_text(0, DataHandler.ids_names[item_id])


func _on_market_tree_item_selected():
	var item : TreeItem = get_selected()
	var item_name = item.get_text( 0 )
	if item_name[-1] == " ":
		item.collapsed = !item.collapsed
		item.deselect(0)
	else:
		if item_name in DataHandler.names_ids:
			var id = DataHandler.names_ids[item_name]
			print( item_name, " ", id )
			emit_signal("item_id_selected", id)
		else:
			print( "ERROR UNKNOWN ITEM NAME ", item_name)

