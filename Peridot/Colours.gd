extends Node



func getEsc(code):
	var escape = PoolByteArray([0x1b]).get_string_from_ascii()
	return('{escape}[{code}m'.format({'escape': escape, 'code': code}))



var RESET = getEsc('0')

var BOLD = getEsc('1')

var RED = getEsc('31')
var GREEN = getEsc('32')
var YELLOW = getEsc('33')
