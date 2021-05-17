extends Node
class_name Nodes



class BaseNode:
	var Lexer = Peridot.Lexer
	var Tokens = Peridot.Tokens
	var start
	var end

class NullNode:
	extends BaseNode
	func _repr():
		return('Void')



class IntNode:
	extends BaseNode
	var token
	func _init(token_):
		self.token = token_
	func _repr():
		return(str(self.token.value))



class FloatNode:
	extends BaseNode
	var token
	func _init(token_):
		self.token = token_
	func _repr():
		return(str(self.token.value))



class BinaryOpNode:
	extends BaseNode
	var left
	var token
	var right
	func _init(left_, token_, right_):
		self.left = left_
		self.token = token_
		self.right = right_
	func _repr():
		return('({left} {op} {right})'.format({'left': self.left._repr(), 'op': Tokens.getName(self.token), 'right': self.right._repr()}))



class UnaryOpNode:
	extends BaseNode
	var token
	var node
	func _init(token_, node_):
		self.token = token_
		self.node = node_
	func _repr():
		return('({token} {node})'.format({'token': Tokens.getName(self.token), 'node': self.node._repr()}))
