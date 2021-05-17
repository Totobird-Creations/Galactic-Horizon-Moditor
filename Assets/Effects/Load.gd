tool
extends RichTextEffect
class_name LoadEffect

var bbcode = 'load'



func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.character = ord('|/-\\'[fmod(char_fx.elapsed_time * 12.0, 4)])
	return(true)
