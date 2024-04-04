extends Control

signal resume_game
signal show_options
signal go_main
signal quit_game

var focused_button

func _ready():
	focused_button = $VBoxContainer/ResumeButton
	focus()

# sets the curr keyboard_focused to focus
func focus():
	if is_instance_valid(focused_button):
		focused_button.grab_focus()

# resume button
func _on_resume_button_pressed():
	emit_signal("resume_game")

# resume button hovering
func _on_resume_button_mouse_entered():
	$VBoxContainer/ResumeButton.grab_focus()

# resume button focused
func _on_resume_button_focus_entered():
	focused_button = $VBoxContainer/ResumeButton
	
# options button
func _on_options_button_pressed():
	emit_signal("show_options")
	
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
	emit_signal("go_main")
	
# main menu button hovering
func _on_main_menu_button_mouse_entered():
	$VBoxContainer/MainMenuButton.grab_focus()

# main menu button focused
func _on_main_menu_button_focus_entered():
	focused_button = $VBoxContainer/MainMenuButton
