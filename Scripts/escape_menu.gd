extends Control

var main_instance
var focused_button
var paused = false

func _ready():
	focused_button = $VBoxContainer/ResumeButton
	main_instance = get_tree().current_scene
	focus()
	add_to_group("pause_menu")

func _process(delta):
	if Input.is_action_just_pressed("ui_escape") and paused == true:
		paused = false
		main_instance.get_tree().paused = false
		hide()
	elif Input.is_action_just_pressed("ui_escape") and paused == false:
		paused = true
		main_instance.get_tree().paused = true
		show()
		focused_button.grab_focus()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# resume button
func _on_resume_button_pressed():
	paused = false
	main_instance.get_tree().paused = false
	hide()

# resume button hovering
func _on_resume_button_mouse_entered():
	$VBoxContainer/ResumeButton.grab_focus()

# resume button focused
func _on_resume_button_focus_entered():
	focused_button = $VBoxContainer/ResumeButton

func show_pause_menu():
	show()
	

# options button
func _on_options_button_pressed():
	hide()
	get_tree().call_group("options_menu", "set_back_destination", "pause_menu")
	get_tree().call_group("options_menu", "show_options")
	get_tree().call_group("options_menu", "focus")
	

# options button hovering
func _on_options_button_mouse_entered():
	$VBoxContainer/OptionsButton.grab_focus()

# options button focused
func _on_options_button_focus_entered():
	focused_button = $VBoxContainer/OptionsButton



# quit button hovering
func _on_quit_button_pressed():
	get_tree().quit()

# quit button hovering
func _on_quit_button_mouse_entered():
	$VBoxContainer/QuitButton.grab_focus()

# quit button focused
func _on_quit_button_focus_entered():
	focused_button = $VBoxContainer/QuitButton



# main menu button
func _on_main_menu_button_pressed():
	main_instance.get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
# main menu button hovering
func _on_main_menu_button_mouse_entered():
	$VBoxContainer/MainMenuButton.grab_focus()

# main menu button focused
func _on_main_menu_button_focus_entered():
	focused_button = $VBoxContainer/MainMenuButton
