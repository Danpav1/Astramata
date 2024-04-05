extends Control

signal go_back
signal apply_changes(music_volume_db, sfx_volume_db)
signal slider_moved

var focused_button
var music_volume_db
var sfx_volume_db

func _ready():
	focused_button = $VBoxContainer/ApplyButton
	music_volume_db = AudioController.get_music_volume_db()
	sfx_volume_db = AudioController.get_sfx_volume_db()
	$VBoxContainer/Music_Slider.value = music_volume_db
	$VBoxContainer/SFX_Slider.value = sfx_volume_db
	focus()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# apply button
func _on_apply_button_pressed():
	emit_signal("apply_changes", music_volume_db, sfx_volume_db)

# apply button hovering
func _on_apply_button_mouse_entered():
	$VBoxContainer/ApplyButton.grab_focus()

# apply button focused
func _on_apply_button_focus_entered():
	focused_button = $VBoxContainer/ApplyButton

# back button
func _on_back_button_pressed():
	emit_signal("go_back")
	
# back button hovering
func _on_back_button_mouse_entered():
	$VBoxContainer/BackButton.grab_focus()

# back button focused
func _on_back_button_focus_entered():
	focused_button = $VBoxContainer/BackButton

# Music slider changes
func _on_music_slider_value_changed(value):
	emit_signal("slider_moved")
	music_volume_db = value
	
# SFX slider changes
func _on_sfx_slider_value_changed(value):
	emit_signal("slider_moved")
	sfx_volume_db = value
