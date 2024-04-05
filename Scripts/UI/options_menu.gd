extends Control

signal go_back
signal apply_changes

var focused_button

func _ready():
	focused_button = $VBoxContainer/ApplyButton
	focus()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# apply button
func _on_apply_button_pressed():
	emit_signal("apply_changes")

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
	

