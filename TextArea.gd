extends TextEdit



const KEYWORD     = Color(1.0, 0.44, 0.52)
const TYPES       = Color(0.26, 1.0, 0.76)
const STRING      = Color(1.0, 0.93, 0.63)
const COMMENT     = Color(0.78, 0.78, 0.78, 0.5)
const BUILTINFUNC = Color(1.0, 0.93, 0.63)

const PATTERNS = {
	'[0-9]+(?:_[0-9]+)*(?:\\.[0-9_]*[0-9])?' : Color(0.63, 1.0, 0.88),
}



func _ready():
	for keyword in Consts.KEYWORDS:
		add_keyword_color(keyword, KEYWORD)
	for type in Consts.TYPES:
		add_keyword_color(type, TYPES)
	for bif in Consts.BUILTINFUNCS:
		add_keyword_color(bif, BUILTINFUNC)

	add_color_region('\'', '\'', STRING)
	add_color_region('\"', '\"', STRING)
	add_color_region('#', '', COMMENT, true)



func _textAreaEdited() -> void:
	var re = RegEx.new()
	for pattern in PATTERNS.keys():
		re.compile(pattern)
		var searches = re.search_all(text)
		for search in searches:
			add_keyword_color(search.strings[0], PATTERNS[pattern])
