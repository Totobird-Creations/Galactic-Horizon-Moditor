extends Node
class_name Tokens



enum {
	TK_INT,
	TK_FLOAT,
	TK_STRING,

	TK_DOT,
	TK_RANGE,

	TK_PLUS,
	TK_MINUS,
	TK_TIMES,
	TK_DIVBY,
	TK_POW,

	TK_EQEQ,
	TK_NOTEQ,
	TK_LSSTHN,
	TK_LSSTHNEQ,
	TK_GRTTHN,
	TK_GRTTHNEQ,

	TK_CAST,

	TK_LPAREN,
	TK_RPAREN,

	TK_COMMA,
	TK_COLON,

	TK_KEYWORD,
	TK_TYPE,
	TK_IDENTIFIER,

	TK_EOL,
	TK_EOF
}



class Token:
	var type  : int
	var value
	var start
	var end

	func _init(type_: int, value_ = null, start_ = null, end_ = null):
		self.type = type_
		self.value = value_
		assert(start_ != null)
		if (start_ != null):
			self.start = start_.copy()

		if (end_ != null):
			self.end = end_.copy()
		else:
			self.end = start_.copy()
			self.end.advance()

	func _to_string():
		return(str(self.type).pad_zeros(2) + ': ' + str(self.value))



func getName(token) -> String:
	match (token.type):
		(TK_INT)        : return('i%s' % token.value)
		(TK_FLOAT)      : return('f%s' % token.value)
		(TK_STRING)     : return('\'%s\'' % token.value)

		(TK_PLUS)       : return('+')
		(TK_MINUS)      : return('-')
		(TK_TIMES)      : return('*')
		(TK_DIVBY)      : return('/')
		(TK_POW)        : return('**')

		(TK_EQEQ)       : return('==')
		(TK_NOTEQ)      : return('!=')
		(TK_LSSTHN)     : return('<')
		(TK_LSSTHNEQ)   : return('<=')
		(TK_GRTTHN)     : return('>')
		(TK_GRTTHNEQ)   : return('>=')

		(TK_CAST)       : return('>>')

		(TK_LPAREN)     : return('(')
		(TK_RPAREN)     : return(')')

		(TK_COMMA)      : return(',')
		(TK_COLON)      : return(':')

		(TK_KEYWORD), (TK_TYPE), (TK_IDENTIFIER) : return(token.value)

		(TK_EOL)        : return('|EOL')
		(TK_EOF)        : return('|EOF')

		_               : return('invalid')
