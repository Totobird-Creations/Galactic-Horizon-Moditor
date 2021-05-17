extends Control

var Lexer = Peridot.Lexer
var Parser = Peridot.Parser



func _input(_event: InputEvent) -> void:
	if (Input.is_action_just_pressed('navbar_run')):
		console_run()



func _notification(notif: int) -> void:
	match (notif):
		MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
			get_tree().quit()



func dumpToConsole(text: String, overwrite: bool = false) -> void:
	if (overwrite):
		$Layout/Right/Bottom/Console.bbcode_text = '\n' + text
	else:
		$Layout/Right/Bottom/Console.bbcode_text += '\n' + text



func console_run() -> void:
	$Layout/Right/Bottom/Console.bbcode_text = '\nLoading [load]_[/load]'

	var lexer = Lexer
	var text = $Layout/Right/Top/TextArea.text
	var lex = lexer.lex('<main>', text)

	if (lex.exception != null):
		dumpToConsole(lex.exception._repr(), true)

	else:
		var parser = Parser
		var parse = parser.parse(lex.result)

		if (parse.error != null):
			dumpToConsole(parse.error._repr(), true)
		else:
			dumpToConsole(parse.node._repr(), true)

	dumpToConsole('[color=grey]--- Debugging process stopped ---[/color]')
