extends Label

var dialog_speed = 0.5

var _tween: Tween = null

signal done()

func speak(new_text: String):
	if _tween:
		_tween.kill()
	text = new_text
	visible_characters = 0
	_tween = create_tween()
	_tween.tween_property(self, "visible_characters", text.length(), dialog_speed)
	await _tween.finished
	self._tween = null
	done.emit()
