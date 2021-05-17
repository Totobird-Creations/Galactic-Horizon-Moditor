extends Node
class_name Errors



class LexingException:
	var name = 'LexingException'
	var msg
	var start
	var end

	func _init(msg_, start_, end_):
		self.msg = msg_
		self.start = start_
		self.end = end_

	func _repr():
		var exc = ''
		exc += '[color=red]-- [b]LEXING EXCEPTION[/b] --[/color]' + '\n'
		exc += '  [color=green]File[/color] `[color=green][b]' + self.start.file + '[/b][/color]`\n'
		exc += '  [color=green]Line[/color] [color=green][b]' + str(self.start.line + 1) + '[/b][/color], '
		exc += '[color=green]Column[/color] [color=green][b]' + str(self.start.column + 1) + '[/b][/color]\n'
		exc += '    [color=yellow][b]' + self.start.lines[self.start.line] + '[/b][/color]\n'
		exc += '    ' + ' '.repeat(self.start.column) + '[color=yellow]' + '^'.repeat(self.end.index - self.start.index) + '[/color]\n'
		exc += '[color=red]----------------------[/color]\n'
		exc += '  [[color=red]' + str(hash(self.name)) + '[/color]]\n  [color=red][b]' + self.name + '[/b][/color]:\n    [color=red]' + self.msg + '[/color]\n'
		exc += '[color=red]----------------------[/color]'
		return(exc)



class ParsingException:
	var name = 'ParsingException'
	var msg
	var start
	var end

	func _init(msg_, start_, end_):
		self.msg = msg_
		self.start = start_
		self.end = end_

	func _repr():
		var exc = ''
		exc += '[color=red]-- [b]PARSING EXCEPTION[/b] --[/color]' + '\n'
		exc += '  [color=green]File[/color] `[color=green][b]' + self.start.file + '[/b][/color]`\n'
		exc += '  [color=green]Line[/color] [color=green][b]' + str(self.start.line + 1) + '[/b][/color], '
		exc += '[color=green]Column[/color] [color=green][b]' + str(self.start.column + 1) + '[/b][/color]\n'
		exc += '    [color=yellow][b]' + self.start.lines[self.start.line] + '[/b][/color]\n'
		exc += '    ' + ' '.repeat(self.start.column) + '[color=yellow]' + '^'.repeat(self.end.index - self.start.index) + '[/color]\n'
		exc += '[color=red]----------------------[/color]\n'
		exc += '  [[color=red]' + str(hash(self.name)) + '[/color]]\n  [color=red][b]' + self.name + '[/b][/color]:\n    [color=red]' + self.msg + '[/color]\n'
		exc += '[color=red]----------------------[/color]'
		return(exc)
