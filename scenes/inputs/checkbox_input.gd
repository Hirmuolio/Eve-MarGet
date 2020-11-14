extends HBoxContainer
tool

export var label : String setget set_label

var value : bool

signal content_change( new_value )

func _ready():
	pass # Replace with function body.

func set_label(new_label):
	label = new_label
	$Label.set("text", new_label)

func _on_CheckBox_pressed():
	value = $CheckBox.pressed
	emit_signal("content_change", value)
