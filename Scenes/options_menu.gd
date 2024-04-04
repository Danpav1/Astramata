extends Control

var main_instance
var focused_button
var back_destination
var back_method

func _ready():
	add_to_group("options_menu")
	focused_button = $VBoxContainer/ApplyButton
	focus()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_escape"):
		#
		hide()

func show_options():
	show()

func set_back_destination(input: String):
	back_destination = input
	if input == "main_menu":
		back_method = "show_main_menu"
	if input == "pause_menu":
		back_method = "show_pause_menu"

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# apply button
func _on_apply_button_pressed():
	print("apply button pressed!")

# apply button hovering
func _on_apply_button_mouse_entered():
	$VBoxContainer/ApplyButton.grab_focus()

# apply button focused
func _on_apply_button_focus_entered():
	focused_button = $VBoxContainer/ApplyButton

# back button
func _on_back_button_pressed():
	if back_destination == "main_menu":
		get_tree().call_group(back_destination, back_method)
	if back_destination == "pause_menu":
		get_tree().call_group(back_destination, back_method)
	hide()
	
# back button hovering
func _on_back_button_mouse_entered():
	$VBoxContainer/BackButton.grab_focus()

# back button focused
func _on_back_button_focus_entered():
	focused_button = $VBoxContainer/BackButton
