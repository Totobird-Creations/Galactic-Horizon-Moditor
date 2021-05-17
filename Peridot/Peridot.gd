extends Node



var Lexer = load('res://Peridot/Lexer.gd').new()
var Parser = load('res://Peridot/Parser.gd').new()
var Interpreter = load('res://Peridot/Interpreter.gd').new()

var Tokens = load('res://Peridot/Tokens.gd').new()
var Nodes = load('res://Peridot/Nodes.gd').new()

var Consts = load('res://Peridot/Consts.gd').new()

var Errors = load('res://Peridot/Errors.gd').new()
