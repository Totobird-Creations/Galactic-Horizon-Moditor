tool
extends Control

var leftrightslider = false
var updownslider = false



func sizeChanged() -> void:
	var size = get_viewport().size

	if ($Slider.margin_left < $Left.rect_min_size.x):
		$Left.rect_size.x = $Left.rect_min_size.x
		$Slider.margin_left = $Left.rect_min_size.x
		$Slider.margin_right = $Slider.margin_left + 12
		sizeChanged()
	else:
		$Left.rect_size.x = $Slider.margin_left

	if (size.x - $Slider.margin_right < $Right.rect_min_size.x):
		$Right.margin_left = -$Right.rect_min_size.x
		$Slider.margin_right = size.x - $Right.rect_min_size.x
		$Slider.margin_left = $Slider.margin_right - 12
		sizeChanged()
	else:
		$Right.margin_left = $Slider.margin_right

	if (-$Right/Slider.margin_bottom < $Right/Bottom.rect_min_size.y):
		$Right/Bottom.margin_top = -$Right/Bottom.rect_min_size.y
		$Right/Slider.margin_bottom = -$Right/Bottom.rect_min_size.y
		$Right/Slider.margin_top = $Right/Slider.margin_bottom - 12
		sizeChanged()
	else:
		$Right/Bottom.margin_top = $Right/Slider.margin_bottom

	if (size.y + $Right/Slider.margin_top < $Right/Top.rect_min_size.y):
		$Right/Top.rect_size.y = $Right/Top.rect_min_size.y
		$Right/Slider.margin_top = -(size.y - $Right/Top.rect_min_size.y)
		$Right/Slider.margin_bottom = $Right/Slider.margin_top + 12
		sizeChanged()
	else:
		$Right/Top.rect_size.y = -$Right/Slider.margin_bottom

	$Slider/MultiSlider.margin_bottom = $Right/Slider.margin_bottom
	$Slider/MultiSlider.margin_top = $Right/Slider.margin_top - 12



func leftrightslider_down() -> void:
	leftrightslider = true
func leftrightslider_up() -> void:
	leftrightslider = false

func updownslider_down() -> void:
	updownslider = true
func updownslider_up() -> void:
	updownslider = false

func multislider_down() -> void:
	leftrightslider = true
	updownslider = true
func multislider_up() -> void:
	leftrightslider = false
	updownslider = false



func _input(event: InputEvent):
	if (event is InputEventMouseMotion):
		if (leftrightslider):
			$Slider.margin_left = event.position.x
			$Slider.margin_right = $Slider.margin_left + 12
			sizeChanged()
		if (updownslider):
			$Right/Slider.margin_bottom = -(get_viewport().size.y - event.position.y)
			$Right/Slider.margin_top = $Right/Slider.margin_bottom - 12
			sizeChanged()
