extends Node
class_name Consts



const NUMERIC = '0123456789'
const ALPHABET = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
const ALPHANUMERIC = NUMERIC + ALPHABET

const KEYWORDS = [
	'var',
	'cst',

	'if',
	'elif',
	'else',

	'for',
	'in',
	'while',

	'func',
	'struct'
]

const TYPES = [
	'Str',
	'Int',
	'Float',
	'Bool',
	'Array',

	'Func',

	'Null',
	'Void'
]

const BUILTINFUNCS = [
	'include',

	'throw',
	'assert',
	'panic',

	'print',
	'range'
]
