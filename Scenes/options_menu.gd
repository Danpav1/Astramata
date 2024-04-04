extends Control

var main_instance
var focused_button

func _ready():
	focused_button = $VBoxContainer/ApplyButton
	focus()
	add_to_group("options_menu")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_escape"):
		#
		hide()

func show_options():
	show()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# apply button
func _on_apply_button_pressed():
	pass

# apply button hovering
func _on_apply_button_mouse_entered():
	$VBoxContainer/ApplyButton.grab_focus()

# apply button focused
func _on_apply_button_focus_entered():
	focused_button = $VBoxContainer/ApplyButton



# back button
func _on_back_button_pressed():
	hide()
	get_tree().call_group("main_menu", "show_main_menu")
	
# back button hovering
func _on_back_button_mouse_entered():
	$VBoxContainer/BackButton.grab_focus()

# back button focused
func _on_back_button_focus_entered():
	focused_button = $VBoxContainer/BackButton
