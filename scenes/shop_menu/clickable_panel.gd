extends PanelContainer

signal clicked()

var _current_tween: Tween

func _ready():
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(release_focus)

func _on_focus_entered():
	_glow_up()
	var stylebox = get_theme_stylebox("panel")
	stylebox.border_width_left = 3
	stylebox.border_width_right = 3
	stylebox.border_width_top = 3
	stylebox.border_width_bottom = 3

func _on_focus_exited():
	_current_tween.kill()
	modulate = Color(1,1,1)
	var stylebox = get_theme_stylebox("panel")
	stylebox.border_width_left = 0
	stylebox.border_width_right = 0
	stylebox.border_width_top = 0
	stylebox.border_width_bottom = 0

func _glow_up():
	_current_tween = self.create_tween()
	_current_tween.tween_property(self, "modulate", Color(2,2,2), 0.5)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE)
	_current_tween.finished.connect(_glow_down)

func _glow_down():
	_current_tween = self.create_tween()
	_current_tween.tween_property(self, "modulate", Color(1,1,1), 0.5)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_SINE)
	_current_tween.finished.connect(_glow_up)

func _gui_input(event):
	if event.is_action_pressed("ui_accept"):
		clicked.emit()
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit()
	
