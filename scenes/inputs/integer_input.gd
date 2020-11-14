extends HBoxContainer
tool

export var label : String setget set_label

var value : int

signal content_change( new_value )

func _ready():
	pass # Replace with function body.

func set_label(new_label):
	label = new_label
	$Label.text = new_label

func set_value( new_value : int ):
	value = new_value
	$integer_field.text = str( new_value )
	pass

func _on_integer_field_content_change(new_value):
	value = new_value
	emit_signal("content_change", new_value)
