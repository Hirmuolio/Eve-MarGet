extends HBoxContainer
tool

export var label : String setget set_label

var value : int

signal content_change( new_value )

func _ready():
	pass

func set_label(new_label):
	label = new_label
	$Label.text = new_label

func add_options( options : Array):
	for option in options:
		$OptionButton.add_item( option )

func set_value( new_value : int ):
	$OptionButton.selected = new_value
	pass

func _on_CheckBox_pressed():
	value = $CheckBox.pressed
	emit_signal("content_change", value)


func _on_OptionButton_item_selected(index):
	value = $OptionButton.selected
	emit_signal("content_change", value)
