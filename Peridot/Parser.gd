extends Node
class_name Parser

var Tokens = Peridot.Tokens
var Nodes = Peridot.Nodes
var Errors = Peridot.Errors



var tokens
var index
var curtoken



class ParseResult:
	var error
	var node
	var advancecount

	func _init():
		self.error = null
		self.node = null
		self.advancecount = 0

	func registeradvancement():
		self.advancecount += 1

	func registerretreat():
		self.advancecount -= 1

	func register(res):
		#self.advancecount += res.advancecount
		if (res.error != null):
			self.error = res.error
		return(res.node)

	func success(node_):
		self.node = node_
		return(self)

	func failure(error_):
		if (self.error == null or self.advancecount == 0):
			self.error = error_
		return(self)



class ParseResponse:
	var success = null
	var failure = null

	func Success(value: Array):
		self.success = value
		self.failure = null

	func Failure(value):
		self.failure = value
		self.success = null



func advance():
	self.index += 1
	if (self.index < len(self.tokens)):
		self.curtoken = self.tokens[self.index]
	return(self.curtoken)

func retreat():
	self.index -= 1
	if (self.index >= 0):
		self.curtoken = self.token[self.index]
	return(self.curtoken)



func parse(tokens_: Array):
	self.tokens = tokens_
	self.index = -1
	self.advance()

	for token in tokens:
		assert(token is Tokens.Token)

	var res = self.expression()
	if ((not res.error) and (self.curtoken.type != Tokens.TK_EOL)):
		return(res.failure(Errors.ParsingException.new(
			'Expected operation',
			self.curtoken.start, self.curtoken.end
		)))
	return(res)



##################################################
# GRAMMAR
#
#
# expression : term ((PLUS|MINUS) term)*
#
# term       : factor ((TIMES, DIVBY) factor)*
#
# factor     : INT|FLOAT
#            : (PLUS|MINUS) factor
#            : LPAREN expression RPAREN
#
##################################################



func binaryop(leftfunc: String, ops: Array, rightfunc: String):
	var res = ParseResult.new()
	var left = res.register(call(leftfunc))
	if (res.error):
		return (res)

	var operation
	var right

	while (self.curtoken.type in ops):
		operation = self.curtoken
		res.registeradvancement()
		self.advance()
		right = res.register(call(rightfunc))
		if (res.error):
			return(res)
		left = Nodes.BinaryOpNode.new(left, operation, right)

	return(res.success(left))



func expression():
	var target = 'term'
	return(self.binaryop(target, [Tokens.TK_PLUS, Tokens.TK_MINUS], target))



func term():
	var target = 'factor'
	return(self.binaryop(target, [Tokens.TK_TIMES, Tokens.TK_DIVBY], target))



func factor():
	var res = ParseResult.new()
	var token = self.curtoken

	match (token.type):
		(Tokens.TK_INT):
			res.registeradvancement()
			self.advance()
			return(res.success(Nodes.IntNode.new(token)))


		(Tokens.TK_FLOAT):
			res.registeradvancement()
			self.advance()
			return(res.success(Nodes.FloatNode.new(token)))


		(Tokens.TK_PLUS), (Tokens.TK_MINUS):
			res.registeradvancement()
			self.advance()

			var factor = res.register(self.factor())
			if (res.error): return(res.error)
			return(res.success(Nodes.UnaryOpNode.new(token, factor)))


		(Tokens.TK_LPAREN):
			res.registeradvancement()
			self.advance()

			var expr = res.register(self.expression())
			if (res.error): return(res)

			if (self.curtoken.type == Tokens.TK_RPAREN):
				res.registeradvancement()
				self.advance()
				return(res.success(expr))

			else:
				return (res.failure(Errors.ParsingException.new(
					'Expected )',
					token.start, token.end
				)))

		_: return (res.failure(Errors.ParsingException.new(
			'Expected int or float',
			token.start, token.end
		)))
