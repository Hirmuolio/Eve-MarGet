extends TextEdit


var value : int

signal content_change( new_value )

func _ready():
	pass # Replace with function body.

func _on_integer_field_text_changed():
	if text.is_valid_integer():
		value = int( text )
		emit_signal("content_change", value)
	else:
		text = str( value )
		cursor_set_column( str(value).length() )
