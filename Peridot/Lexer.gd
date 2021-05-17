extends Node
class_name Lexer

onready var Tokens = Peridot.Tokens



var text
var pos
var ch
var end



class LexerPosition:
	var index  : int
	var line   : int
	var column : int
	var file   : String
	var text   : String
	var lines  : Array

	func _init(file_: String, text_: String, index_: int = -1, line_: int = 0, column_: int = -1):
		self.index = index_
		self.line = line_
		self.column = column_
		self.file = file_
		self.text = text_
		self.lines = text_.split('\n')

	func advance(chr = null):
		self.index += 1
		self.column += 1
		if (chr == '\n'):
			self.line += 1
			self.column = 0
		return(self)

	func retreat(chr = null):
		self.index -= 1
		self.column -= 1
		if (chr == '\n'):
			self.line -= 1
			self.column = len(lines[self.line]) - 1
		return(self)

	func copy():
		return(LexerPosition.new(self.file, self.text, self.index, self.line, self.column))



class LexerResult:
	var result
	var exception

	func _init(result_, exception_):
		self.result = result_
		self.exception = exception_



func lex(file_: String, text_: String):
	self.text = text_
	self.pos  = LexerPosition.new(file_, text_)
	self.ch   = null
	self.end  = false
	self.advance()

	return(maketokens())



func advance():
	self.pos.advance(self.ch)
	if (self.pos.index < len(self.text)):
		self.ch = self.text[self.pos.index]
	else:
		self.end = true
		self.ch = null

func retreat():
	self.pos.retreat(self.ch)
	self.ch = self.text[self.pos.index]
	self.end = false



func maketokens():
	var tokens = []

	while (self.ch != null):


		if (self.ch in ' \t'):
			self.advance()


		elif (self.ch == '\n'):
			tokens.append(Tokens.Token.new(Tokens.TK_EOL, null, self.pos.copy(), self.pos.copy().advance(self.ch)))

			self.advance()


		elif (self.ch in Consts.NUMERIC):
			tokens += self.makenumber()


		elif (self.ch == '+'):
			tokens.append(Tokens.Token.new(Tokens.TK_PLUS, null, self.pos.copy(), self.pos.copy().advance(self.ch)))
			self.advance()


		elif (self.ch == '-'):
			tokens.append(Tokens.Token.new(Tokens.TK_MINUS, null, self.pos.copy(), self.pos.copy().advance(self.ch)))
			self.advance()


		elif (self.ch == '*'):
			tokens.append(Tokens.Token.new(Tokens.TK_TIMES, null, self.pos.copy(), self.pos.copy().advance(self.ch)))
			self.advance()


		elif (self.ch == '/'):
			tokens.append(Tokens.Token.new(Tokens.TK_DIVBY, null, self.pos.copy(), self.pos.copy().advance(self.ch)))
			self.advance()


		elif (self.ch == '('):
			tokens.append(Tokens.Token.new(Tokens.TK_LPAREN, null, self.pos.copy(), self.pos.copy().advance(self.ch)))
			self.advance()


		elif (self.ch == ')'):
			tokens.append(Tokens.Token.new(Tokens.TK_RPAREN, null, self.pos.copy(), self.pos.copy().advance(self.ch)))
			self.advance()


		elif (self.ch in '"\''):
			var result = self.makestring(self.ch)

			if (result.exception != null):
				return(LexerResult.new(null, result.exception))

			tokens.append(result.result)


		elif (self.ch in Consts.ALPHABET + '_'):
			tokens += self.makeidentifier()


		else:
			var start = self.pos.copy()
			var chartemp = self.ch
			self.advance()

			return(
				LexerResult.new(
					null,
					Errors.LexingException.new(
						'Illegal character `%s` was found'.replace('%s', chartemp),
						start, self.pos
					)
				)
			)

	var ed = self.pos.copy()
	ed.advance(self.ch)

	tokens.append(Tokens.Token.new(Tokens.TK_EOL, null, self.pos.copy(), ed.copy()))
	tokens.append(Tokens.Token.new(Tokens.TK_EOF, null, self.pos, ed.copy()))

	return (LexerResult.new(
		tokens,
		null
	))



func makenumber():
	var num = ''
	var dots = 0
	var start = self.pos.copy()

	while ((not self.end) and (self.ch in (Consts.NUMERIC + '._'))):
		if (self.ch == '.'):
			if (dots > 0): break
			dots += 1
			num += '.'
		elif (self.ch != '_'):
			num += self.ch

		self.advance()

	self.retreat()
	if (not self.ch in '._'):
		self.advance()

	if (dots == 0):
		return([Tokens.Token.new(Tokens.TK_INT, int(num), start, self.pos.copy())])
	else:
		return([Tokens.Token.new(Tokens.TK_FLOAT, float(num), start, self.pos.copy())])



func makestring(quotetype: String):
	var string = ''
	var start = self.pos.copy()

	var escchars = {
		'\\' : '\\',
		'n'  : '\n',
		'\n' : '\n',
		't'  : '\t',
		'\'' : '\'',
		'\"' : '\"'
	}

	var escaped = false

	self.advance()

	while ((not self.end) and (self.ch != quotetype or escaped)):
		if (escaped):
			if (not self.ch in escchars.keys()):
				return(LexerResult.new(
					null,
					Errors.LexingException.new(
						'`{ch}` can not be escaped'.format({'ch': self.ch}),
						self.pos.copy().retreat(self.ch), self.pos.copy().advance(self.ch)
					)
				))

			string += escchars.get(self.ch)
			escaped = false

		else:
			if (self.ch == '\\'):
				escaped = true

			elif (self.ch == '\n'):

				return(LexerResult.new(
					null,
					Errors.LexingException.new(
						'Invalid EOL, expected `{ch}`'.format({'ch': quotetype}),
						self.pos.copy(), self.pos.copy().advance(self.ch)
					)
				))

			else:
				string += self.ch

		self.advance()

	if (self.end):
		return(LexerResult.new(
			null,
			Errors.LexingException.new(
				'Invalid EOF, expected `{ch}`'.format({'ch': quotetype}),
				self.pos.copy(), self.pos.copy().advance(self.ch)
			)
		))

	self.advance()

	var token = Tokens.Token.new(Tokens.TK_STRING, string, start, self.pos.copy())
	return(LexerResult.new([token], null))



func makeidentifier():
	var identifier = ''
	var start = self.pos.copy()

	while ((not self.end) and (self.ch in Consts.ALPHANUMERIC + '_')):
		identifier += self.ch
		self.advance()

	var tokentype
	if (identifier in Consts.KEYWORDS):
		tokentype = Tokens.TK_KEYWORD
	elif (identifier in Consts.TYPES):
		tokentype = Tokens.TK_TYPE
	else:
		tokentype = Tokens.TK_IDENTIFIER

	return([Tokens.Token.new(tokentype, identifier, start, self.pos.copy())])
