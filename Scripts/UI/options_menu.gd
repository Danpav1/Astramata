extends Control

signal go_back
signal apply_changes(music_volume_db, sfx_volume_db)
signal slider_moved
signal button_focused

@onready var focused_button = $VBoxContainer/ApplyButton
var music_volume_db
var sfx_volume_db

func _ready():
	music_volume_db = AudioController.get_music_volume_db()
	sfx_volume_db = AudioController.get_sfx_volume_db()
	$VBoxContainer/Music_Slider.value = music_volume_db
	$VBoxContainer/SFX_Slider.value = sfx_volume_db

# sets the curr keyboard_focused to focus
func focus():
	emit_signal("button_focused")
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# apply button
func _on_apply_button_pressed():
	emit_signal("apply_changes", music_volume_db, sfx_volume_db)

# apply button hovering
func _on_apply_button_mouse_entered():
	focused_button = $VBoxContainer/ApplyButton
	focus()

# apply button focused
func _on_apply_button_focus_entered():
	focused_button = $VBoxContainer/ApplyButton
	focus()

# back button
func _on_back_button_pressed():
	emit_signal("go_back")
	
# back button hovering
func _on_back_button_mouse_entered():
	focused_button = $VBoxContainer/BackButton
	focus()

# back button focused
func _on_back_button_focus_entered():
	focused_button = $VBoxContainer/BackButton
	focus()

# Music slider changes
func _on_music_slider_value_changed(value):
	emit_signal("slider_moved")
	music_volume_db = value
	
# SFX slider changes
func _on_sfx_slider_value_changed(value):
	emit_signal("slider_moved")
	sfx_volume_db = value
